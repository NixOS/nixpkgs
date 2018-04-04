# Builds a script to start a Linux x86_64 remote builder using LinuxKit. This
# script relies on darwin-x86_64 and linux-x86_64 dependencies so an existing
# remote builder should be used.

# The VM runs SSH with Nix available, so we can use it as a remote builder.

# TODO: Sadly this file has lots of duplication with vmTools.

{ system
, stdenv
, perl
, xz
, bash
, nix
, pathsFromGraph
, hyperkit
, vpnkit
, linuxkit
, writeScript
, writeScriptBin
, writeText
, forceSystem
, vmTools
, makeInitrd

, linuxkitKernel ? import ./kernel.nix { pkgs = forceSystem "x86_64-linux" "x86_64"; }
, storeDir ? builtins.storeDir

, authorizedKeys ? ./default-key.pub
, privateKey ? ./default-key
, hostPort ? "24083"
}:

let
  pkgsLinux = forceSystem "x86_64-linux" "x86_64";
  vmToolsLinux = vmTools.override { kernel = linuxkitKernel; pkgs = pkgsLinux; };
  containerIp = "192.168.65.2";

  hd = "vda";
  systemTarball = import ../../../../nixos/lib/make-system-tarball.nix {
    inherit stdenv perl xz pathsFromGraph;
    contents = [];
    storeContents = [
      {
        object = stage2Init;
        symlink = "none";
      }
    ];
  };
  stage1Init = writeScript "vm-run-stage1" ''
    #! ${vmToolsLinux.initrdUtils}/bin/ash -e

    export PATH=${vmToolsLinux.initrdUtils}/bin

    mkdir /etc
    echo -n > /etc/fstab

    mount -t proc none /proc
    mount -t sysfs none /sys

    echo 2 > /proc/sys/vm/panic_on_oom

    echo "loading kernel modules..."
    for i in $(cat ${vmToolsLinux.modulesClosure}/insmod-list); do
      insmod $i
    done

    mount -t tmpfs none /dev
    ${vmToolsLinux.createDeviceNodes "/dev"}
    ln -s /proc/self/fd /dev/fd

    ifconfig lo up

    mkdir /fs

    mount /dev/${hd} /fs 2>/dev/null || {
      ${pkgsLinux.e2fsprogs}/bin/mkfs.ext4 -q /dev/${hd}
      mount /dev/${hd} /fs
    } || true

    mkdir -p /fs/dev
    mount -o bind /dev /fs/dev

    mkdir -p /fs/dev/shm /fs/dev/pts
    mount -t tmpfs -o "mode=1777" none /fs/dev/shm
    mount -t devpts none /fs/dev/pts

    echo "extracting Nix store..."
    tar -C /fs -xf ${systemTarball}/tarball/nixos-system-${system}.tar.xz nix nix-path-registration

    mkdir -p /fs/tmp /fs/run /fs/var
    mount -t tmpfs -o "mode=755" none /fs/run
    ln -sfn /run /fs/var/run

    mkdir -p /fs/proc
    mount -t proc none /fs/proc

    mkdir -p /fs/sys
    mount -t sysfs none /fs/sys

    mkdir -p /fs/etc
    ln -sf /proc/mounts /fs/etc/mtab
    echo "127.0.0.1 localhost" > /fs/etc/hosts

    echo "starting stage 2 ($command)"
    exec switch_root /fs $command
  '';

  sshdConfig = writeText "linuxkit-sshd-config" ''
    PermitRootLogin yes
    PasswordAuthentication no
    ChallengeResponseAuthentication no
  '';
  stage2Init = writeScript "vm-run-stage2" ''
    #! ${pkgsLinux.bash}/bin/bash

    export NIX_STORE=${storeDir}
    export NIX_BUILD_TOP=/tmp
    export TMPDIR=/tmp
    cd "$NIX_BUILD_TOP"

    ${pkgsLinux.coreutils}/bin/mkdir -p /bin
    ${pkgsLinux.coreutils}/bin/ln -fs ${pkgsLinux.bash}/bin/sh /bin/sh

    # # Set up automatic kernel module loading.
    export MODULE_DIR=${pkgsLinux.linux}/lib/modules/
    ${pkgsLinux.coreutils}/bin/cat <<EOF > /run/modprobe
    #! /bin/sh
    export MODULE_DIR=$MODULE_DIR
    exec ${pkgsLinux.kmod}/bin/modprobe "\$@"
    EOF
    ${pkgsLinux.coreutils}/bin/chmod 755 /run/modprobe
    echo /run/modprobe > /proc/sys/kernel/modprobe
    ${pkgsLinux.kmod}/bin/modprobe virtio_net

    echo "root:x:0:0:System administrator:/root:${pkgsLinux.bash}/bin/bash" >> /etc/passwd
    echo "sshd:x:1:65534:SSH privilege separation user:/var/empty:${pkgsLinux.shadow}/bin/nologin" >> /etc/passwd
    echo "nixbld1:x:30001:30000:Nix build user 1:/var/empty:${pkgsLinux.shadow}/bin/nologin" >> /etc/passwd
    echo "nixbld:x:30000:nixbld1" >> /etc/group

    export PATH="${vmToolsLinux.initrdUtils}/bin:${pkgsLinux.nix}/bin"

    if [ -f /nix-path-registration ]; then
      cat /nix-path-registration | nix-store --load-db
      rm /nix-path-registration
    fi

    ln -s /dev/pts/ptmx /dev/ptmx
    mkdir -p /etc/ssh /root/.ssh /var/db /var/empty

    ln -s /proc/self/fd/0 /dev/stdin

    ifconfig eth0 ${containerIp}
    route add default gw 192.168.65.1 eth0
    echo 'nameserver 192.168.65.1' > /etc/resolv.conf

    ${pkgsLinux.openssh}/bin/ssh-keygen -A
    echo -n > /root/.bashrc
    echo "export PATH=$PATH" >> /root/.bashrc
    echo "export NIX_SSL_CERT_FILE='${pkgsLinux.cacert}/etc/ssl/certs/ca-bundle.crt'" >> /root/.bashrc
    cp ${authorizedKeys} /root/.ssh/authorized_keys
    chmod 0644 /root/.ssh/authorized_keys

    mkdir -p /port
    mount -v -t 9p -o trans=virtio,dfltuid=1001,dfltgid=50,version=9p2000 port /port

    mkdir -p /etc/acpi/PWRF /etc/acpi/events
    cat >/etc/acpi/PWRF/00000080 <<EOF
    #!/bin/sh
    poweroff
    EOF
    chmod +x "$pkgdir"/etc/acpi/PWRF/00000080
    # ${pkgsLinux.acpid}/bin/acpid -d

    ${pkgsLinux.openssh}/bin/sshd -e -f ${sshdConfig}

    ${pkgsLinux.go-vpnkit}/bin/vpnkit-forwarder &
    ${pkgsLinux.go-vpnkit}/bin/vpnkit-expose-port \
      -i \
      -host-ip 127.0.0.1 -host-port ${hostPort} \
      -container-ip 192.168.65.2 -container-port 22 \
      -no-local-ip &

    mkdir -p /dev/input /etc/acpi/PWRF /var/log
    mknod /dev/input/event0 c 13 64
    cat <<EOF > /etc/acpi/PWRF/00000080
    #!/bin/sh
    poweroff -f
    EOF
    chmod +x /etc/acpi/PWRF/00000080

    echo
    echo -e '\033[91;47m======================================================================'
    echo 'Remote builder has started.'
    echo
    echo 'If this is a fresh VM you need to run the following on the host:'
    echo '    sudo ~/.nixpkgs/linuxkit-builder/root-init.sh'
    echo
    echo 'Then you can use the following to build x86_64-linux derivations:'
    echo '    sudo $(cat ~/.nixpkgs/linuxkit-builder/env) nix-build'
    echo
    echo 'Exit this VM by running:'
    echo '    kill $(cat ~/.nixpkgs/linuxkit-builder/nix-state/hyperkit.pid)'
    echo '======================================================================'
    echo -en '\033[0m'

    exec ${pkgsLinux.busybox}/bin/acpid -f
  '';

  img = "bzImage";
  initrd = makeInitrd {
    contents = [
      { object = stage1Init;
        symlink = "/init";
      }
    ];
  };
  startLinuxKitBuilder = ''
    #!${bash}/bin/bash

    usage() {
      echo "Usage: $(basename $0) [-d directory] [-f features] [-s size] [-c cpus] [-m mem]" >&2
    }

    NAME="linuxkit-builder"

    DIR="$HOME/.nixpkgs/$NAME"
    FEATURES="big-parallel"
    SIZE="10G"
    CPUS=1
    MEM=1024
    while getopts "d:f:s:h" opt; do
      case $opt in
        d) DIR="$OPTARG" ;;
        f) FEATURES="$OPTARG" ;;
        s) SIZE="$OPTARG" ;;
        c) CPUS="$OPTARG" ;;
        m) MEM="$OPTARG" ;;
        h | \?)
          usage
          exit 64
          ;;
      esac
    done

    mkdir -p $DIR
    ln -fs ${linuxkitKernel}/${img} $DIR/nix-kernel
    ln -fs ${initrd}/initrd $DIR/nix-initrd.img
    echo -n "console=ttyS0 panic=1 command=${stage2Init} loglevel=7 debug" > $DIR/nix-cmdline

    [ ! -f $DIR/key ] && {
      cp '${privateKey}' $DIR/key
      chmod 0400 $DIR/key
    }
    echo "root@localhost x86_64-linux $DIR/key $CPUS 1 $FEATURES" > $DIR/remote-systems

    cat <<EOF > $DIR/root-init.sh
    #!/usr/bin/env bash
    if [[ \$EUID -ne 0 ]]; then
      echo "This script should be executed as root." 1>&2
      exit 1
    fi
    chown root $HOME/.nixpkgs/linuxkit-builder/key
    ssh-keygen -R '[localhost]:${hostPort}'
    ssh-keyscan -t ecdsa-sha2-nistp256 -p ${hostPort} localhost >> /var/root/.ssh/known_hosts
    EOF
    chmod +x $DIR/root-init.sh

    ENV=$DIR/env
    echo -n > $ENV
    echo "NIX_REMOTE=" >> $ENV
    echo "NIX_SSHOPTS=-p${hostPort}" >> $ENV
    echo "NIX_BUILD_HOOK=build-remote.pl" >> $ENV
    echo "NIX_REMOTE_SYSTEMS=$DIR/remote-systems" >> $ENV
    echo "NIX_CURRENT_LOAD=$DIR/current-load" >> $ENV

    PATH="${vpnkit}/bin:$PATH"
    exec ${linuxkit}/bin/linuxkit run \
      hyperkit \
      -hyperkit ${hyperkit}/bin/hyperkit $@ \
      -networking vpnkit \
      -ip ${containerIp} \
      -disk $DIR/nix-disk,size=$SIZE \
      -cpus $CPUS \
      -mem $MEM \
      $DIR/nix
  '';
in
writeScriptBin "linuxkit-builder" startLinuxKitBuilder

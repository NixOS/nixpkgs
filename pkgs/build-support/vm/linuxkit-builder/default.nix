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
, buildEnv
, writeScript
, writeScriptBin
, writeText
, writeTextFile
, forceSystem
, vmTools
, makeInitrd

, linuxkitKernel ? import ./kernel.nix { pkgs = forceSystem "x86_64-linux" "x86_64"; }
, storeDir ? builtins.storeDir

, hostPort ? "24083"
}:

let
  writeScriptDir = name: text: writeTextFile {inherit name text; executable = true; destination = "/${name}"; };
  writeRunitForegroundService = name: run: writeTextFile {inherit name; text = run; executable = true; destination = "/${name}/run"; };

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

    if ! mount /dev/${hd} /fs 2>/dev/null; then
      ${pkgsLinux.e2fsprogs}/bin/mkfs.ext4 -q /dev/${hd}
      mount /dev/${hd} /fs
    fi

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
stage2Init = let
    script_modprobe = writeScript "modeprobe" ''
      #! /bin/sh
      export MODULE_DIR=${pkgsLinux.linux}/lib/modules/
      exec ${pkgsLinux.kmod}/bin/modprobe "$@"
    '';

    file_passwd = writeText "passwd" ''
      root:x:0:0:System administrator:/root:${pkgsLinux.bash}/bin/bash
      sshd:x:1:65534:SSH privilege separation user:/var/empty:${pkgsLinux.shadow}/bin/nologin
      nixbld1:x:30001:30000:Nix build user 1:/var/empty:${pkgsLinux.shadow}/bin/nologin
    '';

    file_group = writeText "group" ''
      nixbld:x:30000:nixbld1
      root:x:0:root
    '';

    file_bashrc = writeText "bashrc" ''
      export PATH="${vmToolsLinux.initrdUtils}/bin:${pkgsLinux.nix}/bin"
      export NIX_SSL_CERT_FILE='${pkgsLinux.cacert}/etc/ssl/certs/ca-bundle.crt'
    '';

    script_poweroff = writeText "poweroff" ''
      #!/bin/sh
      exec ${pkgsLinux.busybox}/bin/poweroff
    '';

    script_poweroff_f = writeText "poweroff" ''
      #!/bin/sh
      exec ${pkgsLinux.busybox}/bin/poweroff -f
    '';

    file_instructions = writeText "instructions" ''
      ======================================================================
      Remote builder has started.

      If this is a fresh VM you need to run the following on the host:
          ~/.nixpkgs/linuxkit-builder/finish-setup.sh


      Exit this VM by running:
          kill $(cat ~/.nixpkgs/linuxkit-builder/nix-state/hyperkit.pid)
      ======================================================================
    '';

    runit_targets = buildEnv {
      name = "runit-targets";
      paths = [
        # Startup
        (writeScriptDir "1" ''
          #!/bin/sh
          echo 'Hello world!'
          touch /etc/runit/stopit
          chmod 0 /etc/runit/stopit
        '')

        # Run-time
        (writeScriptDir "2" ''
          #!/bin/sh
          echo "Entering run-time"

          cat /proc/uptime
          echo "Running services in ${service_targets}..."
          exec ${pkgsLinux.runit}/bin/runsvdir -P ${service_targets}
        '')

        # Shutdown
        (writeScriptDir "3" ''
          #!/bin/sh
          echo 'Ok, bye...'
        '')
      ];
    };

    service_targets = buildEnv {
      name = "service-targets";
      paths = [
        (writeRunitForegroundService "acpid" ''
          #!/bin/sh
          exec ${pkgsLinux.busybox}/bin/acpid -f
        '')

        (writeRunitForegroundService "sshd" ''
          #!/bin/sh
          exec ${pkgsLinux.openssh}/bin/sshd -D -e -f ${sshdConfig}
        '')

        (writeRunitForegroundService "vpnkit-forwarder" ''
          #!/bin/sh
          exec ${pkgsLinux.go-vpnkit}/bin/vpnkit-forwarder
        '')

        (writeRunitForegroundService "postboot-instructions" ''
          #!/bin/sh

          sleep 1
          inst() {
            echo
            echo -e '\033[91;47m'
            cat ${file_instructions}
            echo -e '\033[0m'
          }

          inst
          while read x; do inst; done
        '')
      ];
    };
  in writeScript "vm-run-stage2" ''
    #! ${pkgsLinux.bash}/bin/bash -eux

    export NIX_STORE=${storeDir}
    export NIX_BUILD_TOP=/tmp
    export TMPDIR=/tmp
    cd "$NIX_BUILD_TOP"

    ${pkgsLinux.coreutils}/bin/mkdir -p /bin
    ${pkgsLinux.coreutils}/bin/ln -fs ${pkgsLinux.bash}/bin/sh /bin/sh

    # # Set up automatic kernel module loading.
    ${pkgsLinux.coreutils}/bin/cat ${script_modprobe} > /run/modprobe
    ${pkgsLinux.coreutils}/bin/chmod 755 /run/modprobe
    echo /run/modprobe > /proc/sys/kernel/modprobe
    # This never passed, before:
    # + /nix/store/q1yvjh3ab1sb5sn510zla8nlr2r1iimp-kmod-24/bin/modprobe virtio_net
    # modprobe: FATAL: Module virtio_net not found in directory /nix/store/yimxiswgxpps9j19kykddfibj02b4k05-linux-4.9.50/lib/modules//4.9.50-linuxkit
    # /run/modprobe virtio_net

    cat ${file_passwd} > /etc/passwd
    cat ${file_group} > /etc/group

    mkdir -p /etc/ssh /root /var/db /var/empty
    chown root:root /root
    chmod 0700 /root

    cat ${file_bashrc} > /root/.bashrc
    . /root/.bashrc

    if [ -f /nix-path-registration ]; then
      cat /nix-path-registration | nix-store --load-db
      rm /nix-path-registration
    fi

    ln -s /dev/pts/ptmx /dev/ptmx
    ln -s /proc/self/fd/0 /dev/stdin

    ifconfig eth0 ${containerIp}
    route add default gw 192.168.65.1 eth0
    echo 'nameserver 192.168.65.1' > /etc/resolv.conf

    mkdir -p /mnt
    mknod /dev/sr0 b 11 0
    ${pkgsLinux.busybox}/bin/mount /dev/sr0 /mnt

    if [ ! -f /mnt/config ]; then
      echo "FAIL FAIL FAIL"
      echo "You must pass an SSH key data file via via a CDROM (ie: -data on linuxkit)"
      exit 1
    fi

    mkdir /extract-ssh-keys
    (
      rm -rf /root/.ssh
      mkdir -p /root/.ssh
      chmod 0700 /root/.ssh

      cd /extract-ssh-keys
      tar -xf /mnt/config
      chmod 0600 ./*
      chmod 0644 ./*.pub

      mv client.pub /root/.ssh/authorized_keys
      chmod 0600 /root/.ssh/authorized_keys
      chown root:root /root/.ssh/authorized_keys
      mv ssh_host_* /etc/ssh/
    )
    rm -rf /extract-ssh-keys

    mkdir -p /port
    mount -v -t 9p -o trans=virtio,dfltuid=1001,dfltgid=50,version=9p2000 port /port

    mkdir -p /etc/acpi/PWRF /etc/acpi/events
    cat ${script_poweroff} > /etc/acpi/PWRF/00000080
    chmod +x /etc/acpi/PWRF/00000080

    mkdir -p /dev/input /etc/acpi/PWRF /var/log
    mknod /dev/input/event0 c 13 64
    cat ${script_poweroff_f} > /etc/acpi/PWRF/00000080
    chmod +x /etc/acpi/PWRF/00000080

    rm -rf /etc/runit
    cp -r ${runit_targets} /etc/runit/

    exec ${pkgsLinux.runit}/bin/runit
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

    if [ ! -d $DIR/keys ]; then
      mkdir -p $DIR/keys
      (
        cd $DIR/keys
        ssh-keygen -C "Nix LinuxKit Builder, Client" -N "" -f client
        ssh-keygen -C "Nix LinuxKit Builder, Server" -f ssh_host_ecdsa_key -N "" -t ecdsa

        tar -cf server-config.tar client.pub ssh_host_ecdsa_key.pub ssh_host_ecdsa_key

        echo -n '[localhost]:${hostPort} ' > known_host
        cat ssh_host_ecdsa_key.pub >> known_host
      )
    fi

    cp ${./example.nix} $DIR/example.nix


    cat <<-EOF > $DIR/finish-setup.sh
      #!/bin/sh
      cat <<EOI
      1. Add the following to /etc/nix/machines:

        nix-linuxkit x86_64-linux $DIR/keys/client $CPUS 1 $FEATURES

      2. Add the following to /var/root/.ssh/config:

        Host nix-linuxkit
           HostName localhost
           User root
           Port 24083
           IdentityFile $DIR/keys/client
           StrictHostKeyChecking yes
           UserKnownHostsFile $DIR/keys/known_host
           IdentitiesOnly yes

      3. Try it out!

        nix-build $DIR/example.nix


    EOF

    chmod +x $DIR/finish-setup.sh

    PATH="${vpnkit}/bin:$PATH"
    exec ${linuxkit}/bin/linuxkit run \
      hyperkit \
      -hyperkit ${hyperkit}/bin/hyperkit $@ \
      -networking vpnkit \
      -ip ${containerIp} \
      -disk $DIR/nix-disk,size=$SIZE \
      -data $DIR/keys/server-config.tar \
      -cpus $CPUS \
      -mem $MEM \
      $DIR/nix
  '';
in
writeScriptBin "linuxkit-builder" startLinuxKitBuilder

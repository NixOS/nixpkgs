with import <nixpkgs> {};

with import <nixpkgs/nixos/lib/build-vms.nix> {
  inherit system;
  minimal = false;
};

let
  winISO = /path/to/iso/XXX;

  base = import ./install {
    isoFile = winISO;
    productKey = "XXX";
    sshPublicKey = "${snakeOilSSH}/key.pub";
  };

  maybeKvm64 = lib.optional (stdenv.system == "x86_64-linux") "-cpu kvm64";

  cygwinQemuArgs = lib.concatStringsSep " " (maybeKvm64 ++ [
    "-monitor unix:$MONITOR_SOCKET,server,nowait"
    "-nographic"
    "-boot order=c,once=d"
    "-drive file=${base.floppy},readonly,index=0,if=floppy"
    "-drive file=winvm.img,index=0,media=disk"
    "-drive file=${winISO},index=1,media=cdrom"
    "-drive file=${base.iso}/iso/cd.iso,index=2,media=cdrom"
    "-net nic,vlan=0,macaddr=52:54:00:12:01:01"
    "-net vde,vlan=0,sock=$QEMU_VDE_SOCKET"
    "-rtc base=2010-01-01,clock=vm"
  ]);

  modulesClosure = lib.overrideDerivation vmTools.modulesClosure (o: {
    rootModules = o.rootModules ++ lib.singleton "virtio_net";
  });

  snakeOilSSH = stdenv.mkDerivation {
    name = "snakeoil-ssh-cygwin";
    buildCommand = ''
      ensureDir "$out"
      ${openssh}/bin/ssh-keygen -t ecdsa -f "$out/key" -N ""
    '';
  };

  controllerQemuArgs = cmd: let
    preInitScript = writeScript "preinit.sh" ''
      #!${vmTools.initrdUtils}/bin/ash -e
      export PATH=${vmTools.initrdUtils}/bin
      mount -t proc none /proc
      mount -t sysfs none /sys
      for arg in $(cat /proc/cmdline); do
        if [ "x''${arg#command=}" != "x$arg" ]; then
          command="''${arg#command=}"
        fi
      done

      for i in $(cat ${modulesClosure}/insmod-list); do
        insmod $i
      done

      mkdir -p /tmp /dev
      mknod /dev/null    c 1 3
      mknod /dev/zero    c 1 5
      mknod /dev/random  c 1 8
      mknod /dev/urandom c 1 9
      mknod /dev/tty     c 5 0

      ifconfig lo up
      ifconfig eth0 up 192.168.0.2

      mkdir -p /nix/store /etc /var/run /var/log

      cat > /etc/passwd <<PASSWD
      root:x:0:0::/root:/bin/false
      nobody:x:65534:65534::/var/empty:/bin/false
      PASSWD

      mount -t 9p \
        -o trans=virtio,version=9p2000.L,msize=262144,cache=loose \
        store /nix/store

      exec "$command"
    '';
    initrd = makeInitrd {
      contents = lib.singleton {
        object = preInitScript;
        symlink = "/init";
      };
    };
    initScript = writeScript "init.sh" ''
      #!${stdenv.shell}
      ${coreutils}/bin/mkdir -p /etc/samba /etc/samba/private /var/lib/samba
      ${coreutils}/bin/cat > /etc/samba/smb.conf <<CONFIG
      [global]
      security = user
      map to guest = Bad User
      workgroup = cygwin
      netbios name = controller
      server string = %h
      log level = 1
      max log size = 1000
      log file = /var/log/samba.log

      [nixstore]
      path = /nix/store
      read only = no
      guest ok = yes
      CONFIG

      ${samba}/sbin/nmbd -D
      ${samba}/sbin/smbd -D
      ${coreutils}/bin/cp -L "${snakeOilSSH}/key" /ssh.key
      ${coreutils}/bin/chmod 600 /ssh.key

      echo -n "Waiting for Windows VM to become ready"
      while ! ${netcat}/bin/netcat -z 192.168.0.1 22; do
        echo -n .
        ${coreutils}/bin/sleep 1
      done
      echo " ready."

      ${openssh}/bin/ssh \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -i /ssh.key \
        -l Administrator \
        192.168.0.1 -- "${cmd}"

      ${busybox}/sbin/poweroff -f
    '';
    kernelAppend = lib.concatStringsSep " " [
      "panic=1"
      "loglevel=4"
      "console=tty1"
      "console=ttyS0"
      "command=${initScript}"
    ];
  in lib.concatStringsSep " " (maybeKvm64 ++ [
    "-nographic"
    "-no-reboot"
    "-virtfs local,path=/nix/store,security_model=none,mount_tag=store"
    "-kernel ${modulesClosure.kernel}/bzImage"
    "-initrd ${initrd}/initrd"
    "-append \"${kernelAppend}\""
    "-net nic,vlan=0,macaddr=52:54:00:12:01:02,model=virtio"
    "-net vde,vlan=0,sock=$QEMU_VDE_SOCKET"
  ]);

  bootstrap = stdenv.mkDerivation {
    name = "windown-vm";

    buildCommand = ''
      ${qemu}/bin/qemu-img create -f qcow2 winvm.img 2G
      QEMU_VDE_SOCKET="$(pwd)/vde.ctl"
      MONITOR_SOCKET="$(pwd)/monitor"
      ${vde2}/bin/vde_switch -s "$QEMU_VDE_SOCKET" &
      ${vmTools.qemuProg} ${cygwinQemuArgs} &
      ${vmTools.qemuProg} ${controllerQemuArgs "sync"}

      ensureDir "$out"
      ${socat}/bin/socat - UNIX-CONNECT:$MONITOR_SOCKET <<CMD
      stop
      migrate_set_speed 4095m
      migrate "exec:${gzip}/bin/gzip -c > '$out/state.gz'"
      CMD
      cp winvm.img "$out/disk.img"
    '';
  };

in bootstrap

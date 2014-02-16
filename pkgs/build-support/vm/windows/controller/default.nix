{ sshKey
, qemuArgs ? []
, command ? "sync"
, suspendTo ? null
, resumeFrom ? null
, installMode ? false
}:

let
  inherit (import <nixpkgs> {}) lib stdenv writeScript vmTools makeInitrd;
  inherit (import <nixpkgs> {}) samba vde2 busybox openssh;
  inherit (import <nixpkgs> {}) socat netcat coreutils gzip;

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

    mkdir -p /xchg /nix/store /etc /var/run /var/log

    cat > /etc/passwd <<PASSWD
    root:x:0:0::/root:/bin/false
    nobody:x:65534:65534::/var/empty:/bin/false
    PASSWD

    mount -t 9p \
      -o trans=virtio,version=9p2000.L,msize=262144,cache=loose \
      xchg /xchg

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

  shellEscape = x: "'${lib.replaceChars ["'"] [("'\\'" + "'")] x}'";

  loopForever = "while :; do ${coreutils}/bin/sleep 1; done";

  initScript = writeScript "init.sh" (''
    #!${stdenv.shell}
    ${coreutils}/bin/cp -L "${sshKey}" /ssh.key
    ${coreutils}/bin/chmod 600 /ssh.key
  '' + (if installMode then ''
    echo -n "Waiting for Windows installation to finish..."
    while ! ${netcat}/bin/netcat -z 192.168.0.1 22; do
      echo -n .
      # Print a dot every 10 seconds only to shorten line length.
      ${coreutils}/bin/sleep 10
    done
    echo " success."
    # Loop forever, because this VM is going to be killed.
    ${loopForever}
  '' else ''
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

    [xchg]
    path = /xchg
    read only = no
    guest ok = yes
    CONFIG

    ${samba}/sbin/nmbd -D
    ${samba}/sbin/smbd -D
    echo -n "Waiting for Windows VM to become available..."
    while ! ${netcat}/bin/netcat -z 192.168.0.1 22; do
      echo -n .
      ${coreutils}/bin/sleep 1
    done
    echo " success."

    ${openssh}/bin/ssh \
      -o UserKnownHostsFile=/dev/null \
      -o StrictHostKeyChecking=no \
      -i /ssh.key \
      -l Administrator \
      192.168.0.1 -- ${shellEscape command}

    ${lib.optionalString (suspendTo != null) ''
    ${coreutils}/bin/touch /xchg/suspend_now
    ${loopForever}
    ''}
    ${busybox}/sbin/poweroff -f
  ''));

  kernelAppend = lib.concatStringsSep " " [
    "panic=1"
    "loglevel=4"
    "console=tty1"
    "console=ttyS0"
    "command=${initScript}"
  ];

  controllerQemuArgs = lib.concatStringsSep " " (maybeKvm64 ++ [
    "-nographic"
    "-no-reboot"
    "-virtfs local,path=/nix/store,security_model=none,mount_tag=store"
    "-virtfs local,path=$XCHG_DIR,security_model=none,mount_tag=xchg"
    "-kernel ${modulesClosure.kernel}/bzImage"
    "-initrd ${initrd}/initrd"
    "-append \"${kernelAppend}\""
    "-net nic,vlan=0,macaddr=52:54:00:12:01:02,model=virtio"
    "-net vde,vlan=0,sock=$QEMU_VDE_SOCKET"
  ]);

  maybeKvm64 = lib.optional (stdenv.system == "x86_64-linux") "-cpu kvm64";

  cygwinQemuArgs = lib.concatStringsSep " " (maybeKvm64 ++ [
    "-monitor unix:$MONITOR_SOCKET,server,nowait"
    "-nographic"
    "-net nic,vlan=0,macaddr=52:54:00:12:01:01"
    "-net vde,vlan=0,sock=$QEMU_VDE_SOCKET"
    "-rtc base=2010-01-01,clock=vm"
  ] ++ qemuArgs ++ lib.optionals (resumeFrom != null) [
    "-incoming 'exec: ${gzip}/bin/gzip -c -d \"${resumeFrom}\"'"
  ]);

  modulesClosure = lib.overrideDerivation vmTools.modulesClosure (o: {
    rootModules = o.rootModules ++ lib.singleton "virtio_net";
  });

  preVM = ''
    XCHG_DIR="$(${coreutils}/bin/mktemp -d nix-vm.XXXXXXXXXX --tmpdir)"
    QEMU_VDE_SOCKET="$(pwd)/vde.ctl"
    MONITOR_SOCKET="$(pwd)/monitor"
    ${vde2}/bin/vde_switch -s "$QEMU_VDE_SOCKET" &
    echo 'alive?' | ${socat}/bin/socat - \
      UNIX-CONNECT:$QEMU_VDE_SOCKET/ctl,retry=20
  '';

  bgBoth = lib.optionalString (suspendTo != null) " &";

  vmExec = if installMode then ''
    ${vmTools.qemuProg} ${controllerQemuArgs} &
    ${vmTools.qemuProg} ${cygwinQemuArgs}${bgBoth}
  '' else ''
    ${vmTools.qemuProg} ${cygwinQemuArgs} &
    ${vmTools.qemuProg} ${controllerQemuArgs}${bgBoth}
  '' + lib.optionalString (suspendTo != null) ''
    while ! test -e "$XCHG_DIR/suspend_now"; do sleep 1; done
    ${socat}/bin/socat - UNIX-CONNECT:$MONITOR_SOCKET <<CMD
    stop
    migrate_set_speed 4095m
    migrate "exec:${gzip}/bin/gzip -c > '${suspendTo}'"
    quit
    CMD
    wait %-
  '';

in writeScript "run-cygwin-vm.sh" ''
  #!${stdenv.shell} -e
  ${preVM}
  ${vmExec}
''

{ stdenv, writeScript, vmTools, makeInitrd
, samba, vde2, openssh, socat, netcat-gnu, coreutils, gnugrep, gzip
}:

{ sshKey
, qemuArgs ? []
, command ? "sync"
, suspendTo ? null
, resumeFrom ? null
, installMode ? false
}:

with stdenv.lib;

let
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

    mkdir -p /dev /fs

    mount -t tmpfs none /dev
    mknod /dev/null    c 1 3
    mknod /dev/zero    c 1 5
    mknod /dev/random  c 1 8
    mknod /dev/urandom c 1 9
    mknod /dev/tty     c 5 0

    ifconfig lo up
    ifconfig eth0 up 192.168.0.2

    mount -t tmpfs none /fs
    mkdir -p /fs/nix/store /fs/xchg /fs/dev /fs/sys /fs/proc /fs/etc /fs/tmp

    mount -o bind /dev /fs/dev
    mount -t sysfs none /fs/sys
    mount -t proc none /fs/proc

    mount -t 9p \
      -o trans=virtio,version=9p2000.L,cache=loose \
      store /fs/nix/store

    mount -t 9p \
      -o trans=virtio,version=9p2000.L,cache=loose \
      xchg /fs/xchg

    echo root:x:0:0::/root:/bin/false > /fs/etc/passwd

    set +e
    chroot /fs $command $out
    echo $? > /fs/xchg/in-vm-exit

    poweroff -f
  '';

  initrd = makeInitrd {
    contents = singleton {
      object = preInitScript;
      symlink = "/init";
    };
  };

  loopForever = "while :; do ${coreutils}/bin/sleep 1; done";

  initScript = writeScript "init.sh" (''
    #!${stdenv.shell}
    ${coreutils}/bin/cp -L "${sshKey}" /ssh.key
    ${coreutils}/bin/chmod 600 /ssh.key
  '' + (if installMode then ''
    echo -n "Waiting for Windows installation to finish..."
    while ! ${netcat-gnu}/bin/netcat -z 192.168.0.1 22; do
      echo -n .
      # Print a dot every 10 seconds only to shorten line length.
      ${coreutils}/bin/sleep 10
    done
    ${coreutils}/bin/touch /xchg/waiting_done
    echo " success."
    # Loop forever, because this VM is going to be killed.
    ${loopForever}
  '' else ''
    ${coreutils}/bin/mkdir -p /etc/samba /etc/samba/private \
                              /var/lib/samba /var/log /var/run
    ${coreutils}/bin/cat > /etc/samba/smb.conf <<CONFIG
    [global]
    security = user
    map to guest = Bad User
    guest account = root
    workgroup = cygwin
    netbios name = controller
    server string = %h
    log level = 1
    max log size = 1000
    log file = /var/log/samba.log

    [nixstore]
    path = /nix/store
    writable = yes
    guest ok = yes

    [xchg]
    path = /xchg
    writable = yes
    guest ok = yes
    CONFIG

    ${samba}/sbin/nmbd -D
    ${samba}/sbin/smbd -D

    echo -n "Waiting for Windows VM to become available..."
    while ! ${netcat-gnu}/bin/netcat -z 192.168.0.1 22; do
      echo -n .
      ${coreutils}/bin/sleep 1
    done
    ${coreutils}/bin/touch /xchg/waiting_done
    echo " success."

    ${openssh}/bin/ssh \
      -o UserKnownHostsFile=/dev/null \
      -o StrictHostKeyChecking=no \
      -i /ssh.key \
      -l Administrator \
      192.168.0.1 -- ${lib.escapeShellArg command}
  '') + optionalString (suspendTo != null) ''
    ${coreutils}/bin/touch /xchg/suspend_now
    ${loopForever}
  '');

  kernelAppend = concatStringsSep " " [
    "panic=1"
    "loglevel=4"
    "console=tty1"
    "console=ttyS0"
    "command=${initScript}"
  ];

  controllerQemuArgs = concatStringsSep " " (maybeKvm64 ++ [
    "-pidfile $CTRLVM_PIDFILE"
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

  maybeKvm64 = optional (stdenv.hostPlatform.system == "x86_64-linux") "-cpu kvm64";

  cygwinQemuArgs = concatStringsSep " " (maybeKvm64 ++ [
    "-monitor unix:$MONITOR_SOCKET,server,nowait"
    "-pidfile $WINVM_PIDFILE"
    "-nographic"
    "-net nic,vlan=0,macaddr=52:54:00:12:01:01"
    "-net vde,vlan=0,sock=$QEMU_VDE_SOCKET"
    "-rtc base=2010-01-01,clock=vm"
  ] ++ qemuArgs ++ optionals (resumeFrom != null) [
    "-incoming 'exec: ${gzip}/bin/gzip -c -d \"${resumeFrom}\"'"
  ]);

  modulesClosure = overrideDerivation vmTools.modulesClosure (o: {
    rootModules = o.rootModules ++ singleton "virtio_net";
  });

  preVM = ''
    (set; declare -p) > saved-env
    XCHG_DIR="$(${coreutils}/bin/mktemp -d nix-vm.XXXXXXXXXX --tmpdir)"
    ${coreutils}/bin/mv saved-env "$XCHG_DIR/"

    eval "$preVM"

    QEMU_VDE_SOCKET="$(pwd)/vde.ctl"
    MONITOR_SOCKET="$(pwd)/monitor"
    WINVM_PIDFILE="$(pwd)/winvm.pid"
    CTRLVM_PIDFILE="$(pwd)/ctrlvm.pid"
    ${vde2}/bin/vde_switch -s "$QEMU_VDE_SOCKET" --dirmode 0700 &
    echo 'alive?' | ${socat}/bin/socat - \
      UNIX-CONNECT:$QEMU_VDE_SOCKET/ctl,retry=20
  '';

  vmExec = ''
    ${vmTools.qemuProg} ${controllerQemuArgs} &
    ${vmTools.qemuProg} ${cygwinQemuArgs} &
    echo -n "Waiting for VMs to start up..."
    timeout=60
    while ! test -e "$WINVM_PIDFILE" -a -e "$CTRLVM_PIDFILE"; do
      timeout=$(($timeout - 1))
      echo -n .
      if test $timeout -le 0; then
        echo " timed out."
        exit 1
      fi
      ${coreutils}/bin/sleep 1
    done
    echo " done."
  '';

  checkDropOut = ''
    if ! test -e "$XCHG_DIR/waiting_done" &&
       ! kill -0 $(< "$WINVM_PIDFILE"); then
      echo "Windows VM has dropped out early, bailing out!" >&2
      exit 1
    fi
  '';

  toMonitor = "${socat}/bin/socat - UNIX-CONNECT:$MONITOR_SOCKET";

  postVM = if suspendTo != null then ''
    while ! test -e "$XCHG_DIR/suspend_now"; do
      ${checkDropOut}
      ${coreutils}/bin/sleep 1
    done
    ${toMonitor} <<CMD
    stop
    migrate_set_speed 4095m
    migrate "exec:${gzip}/bin/gzip -c > '${suspendTo}'"
    CMD
    echo -n "Waiting for memory dump to finish..."
    while ! echo info migrate | ${toMonitor} | \
          ${gnugrep}/bin/grep -qi '^migration *status: *complete'; do
      ${coreutils}/bin/sleep 1
      echo -n .
    done
    echo " done."
    echo quit | ${toMonitor}
    wait $(< "$WINVM_PIDFILE")
    eval "$postVM"
    exit 0
  '' else if installMode then ''
    wait $(< "$WINVM_PIDFILE")
    eval "$postVM"
    exit 0
  '' else ''
    while kill -0 $(< "$CTRLVM_PIDFILE"); do
      ${checkDropOut}
    done
    if ! test -e "$XCHG_DIR/in-vm-exit"; then
      echo "Virtual machine didn't produce an exit code."
      exit 1
    fi
    eval "$postVM"
    exit $(< "$XCHG_DIR/in-vm-exit")
  '';

in writeScript "run-cygwin-vm.sh" ''
  #!${stdenv.shell} -e
  ${preVM}
  ${vmExec}
  ${postVM}
''

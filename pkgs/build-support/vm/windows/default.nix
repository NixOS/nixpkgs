with import <nixpkgs> {};

with import <nixpkgs/nixos/lib/build-vms.nix> {
  inherit system;
  minimal = false;
};

let
  winISO = /path/to/iso/XXX;

  bootstrapAfterLogin = runCommand "bootstrap.sh" {} ''
    cat > "$out" <<EOF
    mkdir -p ~/.ssh
    cat > ~/.ssh/authorized_keys <<PUBKEY
    $(cat "${snakeOilSSH}/key.pub")
    PUBKEY
    ssh-host-config -y -c 'binmode ntsec' -w dummy
    cygrunsrv -S sshd

    net use S: '\\192.168.0.2\nixstore'
    mkdir -p /nix/store
    mount -o bind /cygdrives/s /nix/store
    EOF
  '';

  productKey = "XXX";

  unattended = /* productKey: */ let
    installCygwin = [ "openssh" ];
    cygwinRoot = "C:\\cygwin";
    afterSetup = [
      "E:\\setup.exe"
      "-L -n -q"
      "-l E:\\"
      "-R ${cygwinRoot}"
      "-C base"
    ] ++ map (p: "-P ${p}") installCygwin;
    runCygShell = args: "${cygwinRoot}\\bin\\bash -l ${args}";
  in writeText "winnt.sif" ''
    [Data]
    AutoPartition = 1
    AutomaticUpdates = 0
    MsDosInitiated = 0
    UnattendedInstall = Yes

    [Unattended]
    DUDisable = Yes
    DriverSigningPolicy = Ignore
    Hibernation = No
    OemPreinstall = No
    OemSkipEula = Yes
    Repartition = Yes
    TargetPath = \WINDOWS
    UnattendMode = FullUnattended
    UnattendSwitch = Yes
    WaitForReboot = No

    [GuiUnattended]
    AdminPassword = "nopasswd"
    AutoLogon = Yes
    AutoLogonCount = 1
    OEMSkipRegional = 1
    OemSkipWelcome = 1
    ServerWelcome = No
    TimeZone = 85

    [UserData]
    ComputerName = "cygwin"
    FullName = "cygwin"
    OrgName = ""
    ProductKey = "${productKey}"

    [Networking]
    InstallDefaultComponents = Yes

    [Identification]
    JoinWorkgroup = cygwin

    [NetAdapters]
    PrimaryAdapter = params.PrimaryAdapter

    [params.PrimaryAdapter]
    InfID = *

    [params.MS_MSClient]

    [NetProtocols]
    MS_TCPIP = params.MS_TCPIP

    [params.MS_TCPIP]
    AdapterSections=params.MS_TCPIP.PrimaryAdapter

    [params.MS_TCPIP.PrimaryAdapter]
    DHCP = No
    IPAddress = 192.168.0.1
    SpecificTo = PrimaryAdapter
    SubnetMask = 255.255.255.0
    WINS = No

    ; Turn off all components
    [Components]
    ${lib.concatMapStrings (comp: "${comp} = Off\n") [
      "AccessOpt" "Appsrv_console" "Aspnet" "BitsServerExtensionsISAPI"
      "BitsServerExtensionsManager" "Calc" "Certsrv" "Certsrv_client"
      "Certsrv_server" "Charmap" "Chat" "Clipbook" "Cluster" "Complusnetwork"
      "Deskpaper" "Dialer" "Dtcnetwork" "Fax" "Fp_extensions" "Fp_vdir_deploy"
      "Freecell" "Hearts" "Hypertrm" "IEAccess" "IEHardenAdmin" "IEHardenUser"
      "Iis_asp" "Iis_common" "Iis_ftp" "Iis_inetmgr" "Iis_internetdataconnector"
      "Iis_nntp" "Iis_serversideincludes" "Iis_smtp" "Iis_webdav" "Iis_www"
      "Indexsrv_system" "Inetprint" "Licenseserver" "Media_clips" "Media_utopia"
      "Minesweeper" "Mousepoint" "Msmq_ADIntegrated" "Msmq_Core"
      "Msmq_HTTPSupport" "Msmq_LocalStorage" "Msmq_MQDSService"
      "Msmq_RoutingSupport" "Msmq_TriggersService" "Msnexplr" "Mswordpad"
      "Netcis" "Netoc" "OEAccess" "Objectpkg" "Paint" "Pinball" "Pop3Admin"
      "Pop3Service" "Pop3Srv" "Rec" "Reminst" "Rootautoupdate" "Rstorage" "SCW"
      "Sakit_web" "Solitaire" "Spider" "TSWebClient" "Templates"
      "TerminalServer" "UDDIAdmin" "UDDIDatabase" "UDDIWeb" "Vol" "WMAccess"
      "WMPOCM" "WbemMSI" "Wms" "Wms_admin_asp" "Wms_admin_mmc" "Wms_isapi"
      "Wms_server" "Zonegames"
    ]}

    [WindowsFirewall]
    Profiles = WindowsFirewall.TurnOffFirewall

    [WindowsFirewall.TurnOffFirewall]
    Mode = 0

    [SetupParams]
    UserExecute = "${lib.concatStringsSep " " afterSetup}"

    [GuiRunOnce]
    Command0 = "${cygwinRoot}\bin\bash -l E:\bootstrap.sh"
  '';

  floppyImg = stdenv.mkDerivation {
    name = "unattended-floppy.img";
    buildCommand = ''
      dd if=/dev/zero of="$out" count=1440 bs=1024
      ${dosfstools}/sbin/mkfs.msdos "$out"
      ${mtools}/bin/mcopy -i "$out" "${unattended}" ::winnt.sif
      ${mtools}/bin/mcopy -i "$out" "${snakeOilSSH}/key.pub" ::ssh.pub
    '';
  };

  qemuCommandWindows = ''
    ${vmTools.qemuProg} \
      ${lib.optionalString (stdenv.system == "x86_64-linux") "-cpu kvm64"} \
      -nographic -no-reboot \
      -virtfs local,path=/nix/store,security_model=none,mount_tag=store \
      -virtfs local,path=$TMPDIR/xchg,security_model=none,mount_tag=xchg \
      -drive file=$diskImage,if=virtio,cache=writeback,werror=report \
      $QEMU_OPTS
  '';

  cygwinMirror = "http://ftp.gwdg.de/pub/linux/sources.redhat.com/cygwin";

  cygPkgList = fetchurl {
    url = "${cygwinMirror}/x86_64/setup.ini";
    sha256 = "0d54pli0gnm3010w9iq2bar3r2sc4syyblg62q75inc2cq341bi3";
  };

  makeCygwinClosure = { packages, packageList }: let
    expr = import (runCommand "cygwin.nix" { buildInputs = [ python ]; } ''
      python ${./mkclosure.py} "${packages}" ${toString packageList} > "$out"
    '');
    gen = { url, md5 }: {
      source = fetchurl {
        url = "${cygwinMirror}/${url}";
        inherit md5;
      };
      target = url;
    };
  in map gen expr;

  cygiso = import <nixpkgs/nixos/lib/make-iso9660-image.nix> {
    inherit (pkgs) stdenv perl cdrkit pathsFromGraph;
    contents = [
      { source = bootstrapAfterLogin;
        target = "bootstrap.sh";
      }
      { source = fetchurl {
          url = "http://cygwin.com/setup-x86_64.exe";
          sha256 = "1bjmq9h1p6mmiqp6f1kvmg94jbsdi1pxfa07a5l497zzv9dsfivm";
        };
        target = "setup.exe";
      }
      { source = cygPkgList;
        target = "setup.ini";
      }
    ] ++ makeCygwinClosure {
      packages = cygPkgList;
      packageList = [ "openssh" ];
    };
  };

  maybeKvm64 = lib.optional (stdenv.system == "x86_64-linux") "-cpu kvm64";

  cygwinQemuArgs = lib.concatStringsSep " " (maybeKvm64 ++ [
    "-monitor unix:$MONITOR_SOCKET,server,nowait"
    "-nographic"
    "-boot order=c,once=d"
    "-drive file=${floppyImg},readonly,index=0,if=floppy"
    "-drive file=winvm.img,index=0,media=disk"
    "-drive file=${winISO},index=1,media=cdrom"
    "-drive file=${cygiso}/iso/cd.iso,index=2,media=cdrom"
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

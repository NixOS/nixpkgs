{ system ? builtins.currentSystem, debug ? false }:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

let
  testVMConfig = vmName: attrs: { config, pkgs, ... }: let
    guestAdditions = pkgs.linuxPackages.virtualboxGuestAdditions;

    miniInit = ''
      #!${pkgs.stdenv.shell} -xe
      export PATH="${pkgs.coreutils}/bin:${pkgs.utillinux}/bin"

      mkdir -p /etc/dbus-1 /var/run/dbus
      cat > /etc/passwd <<EOF
      root:x:0:0::/root:/bin/false
      messagebus:x:1:1::/var/run/dbus:/bin/false
      EOF
      cat > /etc/group <<EOF
      root:x:0:
      messagebus:x:1:
      EOF
      cp -v "${pkgs.dbus.daemon}/etc/dbus-1/system.conf" \
        /etc/dbus-1/system.conf
      "${pkgs.dbus.daemon}/bin/dbus-daemon" --fork --system

      ${guestAdditions}/bin/VBoxService
      ${(attrs.vmScript or (const "")) pkgs}

      i=0
      while [ ! -e /mnt-root/shutdown ]; do
        sleep 10
        i=$(($i + 10))
        [ $i -le 120 ] || fail
      done

      rm -f /mnt-root/boot-done /mnt-root/shutdown
    '';
  in {
    boot.kernelParams = [
      "console=tty0" "console=ttyS0" "ignore_loglevel"
      "boot.trace" "panic=1" "boot.panic_on_fail"
      "init=${pkgs.writeScript "mini-init.sh" miniInit}"
    ];

    fileSystems."/" = {
      device = "vboxshare";
      fsType = "vboxsf";
    };

    virtualisation.virtualbox.guest.enable = true;

    boot.initrd.kernelModules = [
      "af_packet" "vboxsf"
      "virtio" "virtio_pci" "virtio_ring" "virtio_net" "vboxguest"
    ];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs "${guestAdditions}/bin/mount.vboxsf"
      copy_bin_and_libs "${pkgs.utillinux}/bin/unshare"
      ${(attrs.extraUtilsCommands or (const "")) pkgs}
    '';

    boot.initrd.postMountCommands = ''
      touch /mnt-root/boot-done
      hostname "${vmName}"
      mkdir -p /nix/store
      unshare -m "@shell@" -c '
        mount -t vboxsf nixstore /nix/store
        exec "$stage2Init"
      '
      poweroff -f
    '';

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "SERIAL_8250_CONSOLE")
      (isYes "SERIAL_8250")
    ];
  };

  mkLog = logfile: tag: let
    rotated = map (i: "${logfile}.${toString i}") (range 1 9);
    all = concatMapStringsSep " " (f: "\"${f}\"") ([logfile] ++ rotated);
    logcmd = "tail -F ${all} 2> /dev/null | logger -t \"${tag}\"";
  in optionalString debug "$machine->execute(ru '${logcmd} & disown');";

  testVM = vmName: vmScript: let
    cfg = (import ../lib/eval-config.nix {
      system = "i686-linux";
      modules = [
        ../modules/profiles/minimal.nix
        (testVMConfig vmName vmScript)
      ];
    }).config;
  in pkgs.vmTools.runInLinuxVM (pkgs.runCommand "virtualbox-image" {
    preVM = ''
      mkdir -p "$out"
      diskImage="$(pwd)/qimage"
      ${pkgs.vmTools.qemu}/bin/qemu-img create -f raw "$diskImage" 100M
    '';

    postVM = ''
      echo "creating VirtualBox disk image..."
      ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -O vdi \
        "$diskImage" "$out/disk.vdi"
    '';

    buildInputs = [ pkgs.utillinux pkgs.perl ];
  } ''
    ${pkgs.parted}/sbin/parted /dev/vda mklabel msdos
    ${pkgs.parted}/sbin/parted /dev/vda -- mkpart primary ext2 1M -1s
    . /sys/class/block/vda1/uevent
    mknod /dev/vda1 b $MAJOR $MINOR

    ${pkgs.e2fsprogs}/sbin/mkfs.ext4 /dev/vda1
    ${pkgs.e2fsprogs}/sbin/tune2fs -c 0 -i 0 /dev/vda1
    mkdir /mnt
    mount /dev/vda1 /mnt
    cp "${cfg.system.build.kernel}/bzImage" /mnt/linux
    cp "${cfg.system.build.initialRamdisk}/initrd" /mnt/initrd

    ${pkgs.grub2}/bin/grub-install --boot-directory=/mnt /dev/vda

    cat > /mnt/grub/grub.cfg <<GRUB
    set root=hd0,1
    linux /linux ${concatStringsSep " " cfg.boot.kernelParams}
    initrd /initrd
    boot
    GRUB
    umount /mnt
  '');

  createVM = name: attrs: let
    mkFlags = concatStringsSep " ";

    sharePath = "/home/alice/vboxshare-${name}";

    createFlags = mkFlags [
      "--ostype Linux26"
      "--register"
    ];

    vmFlags = mkFlags ([
      "--uart1 0x3F8 4"
      "--uartmode1 client /run/virtualbox-log-${name}.sock"
      "--memory 768"
    ] ++ (attrs.vmFlags or []));

    controllerFlags = mkFlags [
      "--name SATA"
      "--add sata"
      "--bootable on"
      "--hostiocache on"
    ];

    diskFlags = mkFlags [
      "--storagectl SATA"
      "--port 0"
      "--device 0"
      "--type hdd"
      "--mtype immutable"
      "--medium ${testVM name attrs}/disk.vdi"
    ];

    sharedFlags = mkFlags [
      "--name vboxshare"
      "--hostpath ${sharePath}"
    ];

    nixstoreFlags = mkFlags [
      "--name nixstore"
      "--hostpath /nix/store"
      "--readonly"
    ];
  in {
    machine = {
      systemd.sockets."vboxtestlog-${name}" = {
        description = "VirtualBox Test Machine Log Socket For ${name}";
        wantedBy = [ "sockets.target" ];
        before = [ "multi-user.target" ];
        socketConfig.ListenStream = "/run/virtualbox-log-${name}.sock";
        socketConfig.Accept = true;
      };

      systemd.services."vboxtestlog-${name}@" = {
        description = "VirtualBox Test Machine Log For ${name}";
        serviceConfig.StandardInput = "socket";
        serviceConfig.StandardOutput = "syslog";
        serviceConfig.SyslogIdentifier = "GUEST-${name}";
        serviceConfig.ExecStart = "${pkgs.coreutils}/bin/cat";
      };
    };

    testSubs = ''
      my ${"$" + name}_sharepath = '${sharePath}';

      sub checkRunning_${name} {
        my $cmd = 'VBoxManage list runningvms | grep -q "^\"${name}\""';
        my ($status, $out) = $machine->execute(ru $cmd);
        return $status == 0;
      }

      sub cleanup_${name} {
        $machine->execute(ru "VBoxManage controlvm ${name} poweroff")
          if checkRunning_${name};
        $machine->succeed("rm -rf ${sharePath}");
        $machine->succeed("mkdir -p ${sharePath}");
        $machine->succeed("chown alice.users ${sharePath}");
      }

      sub createVM_${name} {
        vbm("createvm --name ${name} ${createFlags}");
        vbm("modifyvm ${name} ${vmFlags}");
        vbm("setextradata ${name} VBoxInternal/PDM/HaltOnReset 1");
        vbm("storagectl ${name} ${controllerFlags}");
        vbm("storageattach ${name} ${diskFlags}");
        vbm("sharedfolder add ${name} ${sharedFlags}");
        vbm("sharedfolder add ${name} ${nixstoreFlags}");
        cleanup_${name};

        ${mkLog "$HOME/VirtualBox VMs/${name}/Logs/VBox.log" "HOST-${name}"}
      }

      sub destroyVM_${name} {
        cleanup_${name};
        vbm("unregistervm ${name} --delete");
      }

      sub waitForVMBoot_${name} {
        $machine->execute(ru(
          'set -e; i=0; '.
          'while ! test -e ${sharePath}/boot-done; do '.
          'sleep 10; i=$(($i + 10)); [ $i -le 3600 ]; '.
          'VBoxManage list runningvms | grep -q "^\"${name}\""; '.
          'done'
        ));
      }

      sub waitForIP_${name} ($) {
        my $property = "/VirtualBox/GuestInfo/Net/$_[0]/V4/IP";
        my $getip = "VBoxManage guestproperty get ${name} $property | ".
                    "sed -n -e 's/^Value: //p'";
        my $ip = $machine->succeed(ru(
          'for i in $(seq 1000); do '.
          'if ipaddr="$('.$getip.')" && [ -n "$ipaddr" ]; then '.
          'echo "$ipaddr"; exit 0; '.
          'fi; '.
          'sleep 1; '.
          'done; '.
          'echo "Could not get IPv4 address for ${name}!" >&2; '.
          'exit 1'
        ));
        chomp $ip;
        return $ip;
      }

      sub waitForStartup_${name} {
        for (my $i = 0; $i <= 120; $i += 10) {
          $machine->sleep(10);
          return if checkRunning_${name};
          eval { $_[0]->() } if defined $_[0];
        }
        die "VirtualBox VM didn't start up within 2 minutes";
      }

      sub waitForShutdown_${name} {
        for (my $i = 0; $i <= 120; $i += 10) {
          $machine->sleep(10);
          return unless checkRunning_${name};
        }
        die "VirtualBox VM didn't shut down within 2 minutes";
      }

      sub shutdownVM_${name} {
        $machine->succeed(ru "touch ${sharePath}/shutdown");
        $machine->waitUntilSucceeds(
          "test ! -e ${sharePath}/shutdown ".
          "  -a ! -e ${sharePath}/boot-done"
        );
        waitForShutdown_${name};
      }
    '';
  };

  hostonlyVMFlags = [
    "--nictype1 virtio"
    "--nictype2 virtio"
    "--nic2 hostonly"
    "--hostonlyadapter2 vboxnet0"
  ];

  dhcpScript = pkgs: ''
    ${pkgs.dhcp}/bin/dhclient \
      -lf /run/dhcp.leases \
      -pf /run/dhclient.pid \
      -v eth0 eth1

    otherIP="$(${pkgs.netcat}/bin/netcat -clp 1234 || :)"
    ${pkgs.iputils}/bin/ping -I eth1 -c1 "$otherIP"
    echo "$otherIP reachable" | ${pkgs.netcat}/bin/netcat -clp 5678 || :
  '';

  sysdDetectVirt = pkgs: ''
    ${pkgs.systemd}/bin/systemd-detect-virt > /mnt-root/result
  '';

  vboxVMs = mapAttrs createVM {
    simple = {};

    detectvirt.vmScript = sysdDetectVirt;

    test1.vmFlags = hostonlyVMFlags;
    test1.vmScript = dhcpScript;

    test2.vmFlags = hostonlyVMFlags;
    test2.vmScript = dhcpScript;
  };

  mkVBoxTest = name: testScript: makeTest {
    name = "virtualbox-${name}";

    machine = { lib, config, ... }: {
      imports = let
        mkVMConf = name: val: val.machine // { key = "${name}-config"; };
        vmConfigs = mapAttrsToList mkVMConf vboxVMs;
      in [ ./common/user-account.nix ./common/x11.nix ] ++ vmConfigs;
      virtualisation.memorySize = 2048;
      virtualisation.virtualbox.host.enable = true;
      services.xserver.displayManager.auto.user = "alice";
      users.extraUsers.alice.extraGroups = let
        inherit (config.virtualisation.virtualbox.host) enableHardening;
      in lib.mkIf enableHardening (lib.singleton "vboxusers");
    };

    testScript = ''
      sub ru ($) {
        my $esc = $_[0] =~ s/'/'\\${"'"}'/gr;
        return "su - alice -c '$esc'";
      }

      sub vbm {
        $machine->succeed(ru("VBoxManage ".$_[0]));
      };

      sub removeUUIDs {
        return join("\n", grep { $_ !~ /^UUID:/ } split(/\n/, $_[0]))."\n";
      }

      ${concatStrings (mapAttrsToList (_: getAttr "testSubs") vboxVMs)}

      $machine->waitForX;

      ${mkLog "$HOME/.config/VirtualBox/VBoxSVC.log" "HOST-SVC"}

      ${testScript}
    '';

    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ aszlig wkennington ];
    };
  };

in mapAttrs mkVBoxTest {
  simple-gui = ''
    createVM_simple;
    $machine->succeed(ru "VirtualBox &");
    $machine->waitUntilSucceeds(
      ru "xprop -name 'Oracle VM VirtualBox Manager'"
    );
    $machine->sleep(5);
    $machine->screenshot("gui_manager_started");
    $machine->sendKeys("ret");
    $machine->screenshot("gui_manager_sent_startup");
    waitForStartup_simple (sub {
      $machine->sendKeys("ret");
    });
    $machine->screenshot("gui_started");
    waitForVMBoot_simple;
    $machine->screenshot("gui_booted");
    shutdownVM_simple;
    $machine->sleep(5);
    $machine->screenshot("gui_stopped");
    $machine->sendKeys("ctrl-q");
    $machine->sleep(5);
    $machine->screenshot("gui_manager_stopped");
  '';

  simple-cli = ''
    createVM_simple;
    vbm("startvm simple");
    waitForStartup_simple;
    $machine->screenshot("cli_started");
    waitForVMBoot_simple;
    $machine->screenshot("cli_booted");

    $machine->nest("Checking for privilege escalation", sub {
      $machine->fail("test -e '/root/VirtualBox VMs'");
      $machine->fail("test -e '/root/.config/VirtualBox'");
      $machine->succeed("test -e '/home/alice/VirtualBox VMs'");
    });

    shutdownVM_simple;
  '';

  host-usb-permissions = ''
    my $userUSB = removeUUIDs vbm("list usbhost");
    print STDERR $userUSB;
    my $rootUSB = removeUUIDs $machine->succeed("VBoxManage list usbhost");
    print STDERR $rootUSB;

    die "USB host devices differ for root and normal user"
      if $userUSB ne $rootUSB;
    die "No USB host devices found" if $userUSB =~ /<none>/;
  '';

  systemd-detect-virt = ''
    createVM_detectvirt;
    vbm("startvm detectvirt");
    waitForStartup_detectvirt;
    waitForVMBoot_detectvirt;
    shutdownVM_detectvirt;
    my $result = $machine->succeed("cat '$detectvirt_sharepath/result'");
    chomp $result;
    destroyVM_detectvirt;
    die "systemd-detect-virt returned \"$result\" instead of \"oracle\""
      if $result ne "oracle";
  '';

  net-hostonlyif = ''
    createVM_test1;
    createVM_test2;

    vbm("startvm test1");
    waitForStartup_test1;
    waitForVMBoot_test1;

    vbm("startvm test2");
    waitForStartup_test2;
    waitForVMBoot_test2;

    $machine->screenshot("net_booted");

    my $test1IP = waitForIP_test1 1;
    my $test2IP = waitForIP_test2 1;

    $machine->succeed("echo '$test2IP' | netcat -c '$test1IP' 1234");
    $machine->succeed("echo '$test1IP' | netcat -c '$test2IP' 1234");

    $machine->waitUntilSucceeds("netcat -c '$test1IP' 5678 >&2");
    $machine->waitUntilSucceeds("netcat -c '$test2IP' 5678 >&2");

    shutdownVM_test1;
    shutdownVM_test2;

    destroyVM_test1;
    destroyVM_test2;
  '';
}

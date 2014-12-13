import ./make-test.nix ({ pkgs, ... }: with pkgs.lib; let

  testVMConfig = { config, pkgs, ... }: {
    boot.kernelParams = [
      "console=tty0" "console=ttyS0" "ignore_loglevel"
      "boot.trace" "panic=1" "boot.panic_on_fail"
    ];

    fileSystems."/" = {
      device = "vboxshare";
      fsType = "vboxsf";
    };

    services.virtualboxGuest.enable = true;

    boot.initrd.kernelModules = [ "vboxsf" ];

    boot.initrd.extraUtilsCommands = ''
      cp -av -t "$out/bin/" \
        "${pkgs.linuxPackages.virtualboxGuestAdditions}/sbin/mount.vboxsf"
    '';

    boot.initrd.postMountCommands = ''
      touch /mnt-root/boot-done

      i=0
      while [ ! -e /mnt-root/shutdown ]; do
        sleep 10
        i=$(($i + 10))
        [ $i -le 120 ] || fail
      done

      rm -f /mnt-root/boot-done /mnt-root/shutdown
      poweroff -f
    '';

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "SERIAL_8250_CONSOLE")
      (isYes "SERIAL_8250")
    ];
  };

  testVM = let
    cfg = (import ../lib/eval-config.nix {
      system = "i686-linux";
      modules = [
        ../modules/profiles/minimal.nix
        testVMConfig
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

  createVM = name: let
    mkFlags = concatStringsSep " ";

    sharePath = "/home/alice/vboxshare-${name}";

    createFlags = mkFlags [
      "--ostype Linux26"
      "--register"
    ];

    vmFlags = mkFlags [
      "--uart1 0x3F8 4"
      "--uartmode1 client /run/virtualbox-log-${name}.sock"
    ];

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
      "--medium ${testVM}/disk.vdi"
    ];

    sharedFlags = mkFlags [
      "--name vboxshare"
      "--hostpath ${sharePath}"
    ];
  in {
    machine = {
      systemd.sockets = listToAttrs (singleton {
        name = "vboxtestlog-${name}";
        value = {
          description = "VirtualBox Test Machine Log Socket";
          wantedBy = [ "sockets.target" ];
          before = [ "multi-user.target" ];
          socketConfig.ListenStream = "/run/virtualbox-log-${name}.sock";
          socketConfig.Accept = true;
        };
      });

      systemd.services = listToAttrs (singleton {
        name = "vboxtestlog-${name}@";
        value = {
          description = "VirtualBox Test Machine Log";
          serviceConfig.StandardInput = "socket";
          serviceConfig.StandardOutput = "syslog";
          serviceConfig.SyslogIdentifier = "vbox-${name}";
          serviceConfig.ExecStart = "${pkgs.coreutils}/bin/cat";
        };
      });
    };

    testSubs = ''
      sub createVM_${name} {
        vbm("createvm --name ${name} ${createFlags}");
        vbm("modifyvm ${name} ${vmFlags}");
        vbm("storagectl ${name} ${controllerFlags}");
        vbm("storageattach ${name} ${diskFlags}");
        vbm("sharedfolder add ${name} ${sharedFlags}");
        vbm("showvminfo ${name} >&2");
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

      sub checkRunning_${name} {
        my $cmd = 'VBoxManage list runningvms | grep -q "^\"${name}\""';
        my ($status, $out) = $machine->execute(ru $cmd);
        return $status == 0;
      }

      sub waitForStartup_${name} {
        for (my $i = 0; $i <= 120; $i += 10) {
          $machine->sleep(10);
          return if checkRunning_${name};
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

      sub cleanup_${name} {
        $machine->execute(ru "VBoxManage controlvm ${name} poweroff")
          if checkRunning_${name};
        $machine->succeed("rm -rf ${sharePath}");
        $machine->succeed("mkdir -p ${sharePath}");
        $machine->succeed("chown alice.users ${sharePath}");
      }
    '';
  };

  vboxVMs.test1 = createVM "test1";

in {
  name = "virtualbox";

  machine = { pkgs, ... }: {
    imports = let
      mkVMConf = name: val: val.machine // { key = "${name}-config"; };
      vmConfigs = mapAttrsToList mkVMConf vboxVMs;
    in [ ./common/user-account.nix ./common/x11.nix ] ++ vmConfigs;
    services.virtualboxHost.enable = true;
  };

  testScript = ''
    sub ru {
      return "su - alice -c '$_[0]'";
    }

    sub vbm {
      $machine->succeed(ru("VBoxManage ".$_[0]));
    };

    ${concatStrings (mapAttrsToList (_: getAttr "testSubs") vboxVMs)}

    $machine->waitForX;

    createVM_test1;

    cleanup_test1;

    subtest "simple-gui", sub {
      $machine->succeed(ru "VirtualBox &");
      $machine->waitForWindow(qr/Oracle VM VirtualBox Manager/);
      $machine->sleep(5);
      $machine->screenshot("gui_manager_started");
      $machine->sendKeys("ret");
      $machine->screenshot("gui_manager_sent_startup");
      waitForStartup_test1;
      $machine->screenshot("gui_started");
      waitForVMBoot_test1;
      $machine->screenshot("gui_booted");
      shutdownVM_test1;
      $machine->sleep(5);
      $machine->screenshot("gui_stopped");
      $machine->sendKeys("ctrl-q");
      $machine->sleep(5);
      $machine->screenshot("gui_manager_stopped");
    };

    cleanup_test1;

    subtest "simple-cli", sub {
      vbm("startvm test1");
      waitForStartup_test1;
      $machine->screenshot("cli_started");
      waitForVMBoot_test1;
      $machine->screenshot("cli_booted");
      shutdownVM_test1;
    };

    cleanup_test1;

    $machine->fail("test -e '/root/VirtualBox VMs'");
    $machine->succeed("test -e '/home/alice/VirtualBox VMs'");
  '';
})

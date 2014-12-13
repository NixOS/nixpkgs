import ./make-test.nix ({ pkgs, ... }: let

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
    linux /linux ${pkgs.lib.concatStringsSep " " cfg.boot.kernelParams}
    initrd /initrd
    boot
    GRUB
    umount /mnt
  '');

in {
  name = "virtualbox";

  machine = { pkgs, ... }: {
    imports = [ ./common/user-account.nix ./common/x11.nix ];
    services.virtualboxHost.enable = true;

    systemd.sockets.vboxtestlog = {
      description = "VirtualBox Test Machine Log Socket";
      wantedBy = [ "sockets.target" ];
      before = [ "multi-user.target" ];
      socketConfig.ListenStream = "/run/virtualbox-log.sock";
      socketConfig.Accept = true;
    };

    systemd.services."vboxtestlog@" = {
      description = "VirtualBox Test Machine Log";
      serviceConfig.StandardInput = "socket";
      serviceConfig.StandardOutput = "syslog";
      serviceConfig.SyslogIdentifier = "testvm";
      serviceConfig.ExecStart = "${pkgs.coreutils}/bin/cat";
    };
  };

  testScript = let
    mkFlags = pkgs.lib.concatStringsSep " ";

    createFlags = mkFlags [
      "--ostype Linux26"
      "--register"
    ];

    vmFlags = mkFlags [
      "--uart1 0x3F8 4"
      "--uartmode1 client /run/virtualbox-log.sock"
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
      "--hostpath /home/alice/vboxshare"
    ];
  in ''
    sub ru {
      return "su - alice -c '$_[0]'";
    }

    sub waitForVMBoot {
      $machine->execute(ru(
        'set -e; i=0; '.
        'while ! test -e /home/alice/vboxshare/boot-done; do '.
        'sleep 10; i=$(($i + 10)); [ $i -le 3600 ]; '.
        'VBoxManage list runningvms | grep -qF test; '.
        'done'
      ));
    }

    sub checkRunning {
      my $checkrunning = ru "VBoxManage list runningvms | grep -qF test";
      my ($status, $out) = $machine->execute($checkrunning);
      return $status == 0;
    }

    sub waitForStartup {
      for (my $i = 0; $i <= 120; $i += 10) {
        $machine->sleep(10);
        return if checkRunning;
      }
      die "VirtualBox VM didn't start up within 2 minutes";
    }

    sub waitForShutdown {
      for (my $i = 0; $i <= 120; $i += 10) {
        $machine->sleep(10);
        return unless checkRunning;
      }
      die "VirtualBox VM didn't shut down within 2 minutes";
    }

    sub shutdownVM {
      $machine->succeed(ru "touch /home/alice/vboxshare/shutdown");
      $machine->waitUntilSucceeds(
        "test ! -e /home/alice/vboxshare/shutdown ".
        "  -a ! -e /home/alice/vboxshare/boot-done"
      );
      waitForShutdown;
    }

    sub cleanup {
      $machine->execute(ru "VBoxManage controlvm test poweroff")
        if checkRunning;
      $machine->succeed("rm -rf /home/alice/vboxshare");
      $machine->succeed("mkdir -p /home/alice/vboxshare");
      $machine->succeed("chown alice.users /home/alice/vboxshare");
    }

    $machine->waitForX;

    $machine->succeed(ru "VBoxManage createvm --name test ${createFlags}");
    $machine->succeed(ru "VBoxManage modifyvm test ${vmFlags}");

    $machine->fail("test -e '/root/VirtualBox VMs'");
    $machine->succeed("test -e '/home/alice/VirtualBox VMs'");

    $machine->succeed(ru "VBoxManage storagectl test ${controllerFlags}");
    $machine->succeed(ru "VBoxManage storageattach test ${diskFlags}");

    $machine->succeed(ru "VBoxManage sharedfolder add test ${sharedFlags}");

    $machine->succeed(ru "VBoxManage showvminfo test >&2");

    cleanup;

    subtest "virtualbox-gui", sub {
      $machine->succeed(ru "VirtualBox &");
      $machine->waitForWindow(qr/Oracle VM VirtualBox Manager/);
      $machine->sleep(5);
      $machine->screenshot("gui_manager_started");
      $machine->sendKeys("ret");
      $machine->screenshot("gui_manager_sent_startup");
      waitForStartup;
      $machine->screenshot("gui_started");
      waitForVMBoot;
      $machine->screenshot("gui_booted");
      shutdownVM;
      $machine->sleep(5);
      $machine->screenshot("gui_stopped");
      $machine->sendKeys("ctrl-q");
      $machine->sleep(5);
      $machine->screenshot("gui_manager_stopped");
    };

    cleanup;

    subtest "virtualbox-cli", sub {
      $machine->succeed(ru "VBoxManage startvm test");
      waitForStartup;
      $machine->screenshot("cli_started");
      waitForVMBoot;
      $machine->screenshot("cli_booted");
      shutdownVM;
    };

    $machine->fail("test -e '/root/VirtualBox VMs'");
    $machine->succeed("test -e '/home/alice/VirtualBox VMs'");
  '';
})

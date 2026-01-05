{
  runTest,
  runTestOn,
  ...
}:

let
  common =
    { pkgs, ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      environment.systemPackages = [ pkgs.efibootmgr ];
      system.switch.enable = true;
    };

  commonXbootldr =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      diskImage = import ../lib/make-disk-image.nix {
        inherit config lib pkgs;
        label = "nixos";
        format = "qcow2";
        partitionTableType = "efixbootldr";
        touchEFIVars = true;
        installBootLoader = true;
        # Don't copy the channel to avoid rebuilding this image, and all tests
        # that use it, every time that nixpkgs changes
        copyChannel = false;
      };
    in
    {
      imports = [ common ];
      virtualisation.useBootLoader = lib.mkForce false; # Only way to tell qemu-vm not to create the default system image
      virtualisation.directBoot.enable = false; # But don't direct boot either because we're testing systemd-boot

      system.build.diskImage = diskImage; # Use custom disk image with an XBOOTLDR partition
      virtualisation.efi.variables = "${diskImage}/efi-vars.fd";

      virtualisation.useDefaultFilesystems = false; # Needs custom setup for `diskImage`
      virtualisation.bootPartition = null;
      virtualisation.fileSystems = {
        "/" = {
          device = "/dev/vda3";
          fsType = "ext4";
        };
        "/boot" = {
          device = "/dev/vda2";
          fsType = "vfat";
          noCheck = true;
        };
        "/efi" = {
          device = "/dev/vda1";
          fsType = "vfat";
          noCheck = true;
        };
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.efiSysMountPoint = "/efi";
      boot.loader.systemd-boot.xbootldrMountPoint = "/boot";
    };

  customDiskImage = nodes: ''
    import os
    import subprocess
    import tempfile

    tmp_disk_image = tempfile.NamedTemporaryFile()

    subprocess.run([
      "${nodes.machine.virtualisation.qemu.package}/bin/qemu-img",
      "create",
      "-f",
      "qcow2",
      "-b",
      "${nodes.machine.system.build.diskImage}/nixos.qcow2",
      "-F",
      "qcow2",
      tmp_disk_image.name,
    ])

    # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
    os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name
  '';
in
{
  basic = runTest (
    { lib, ... }:
    {
      name = "systemd-boot";
      meta.maintainers = with lib.maintainers; [
        danielfullmer
        julienmalka
      ];

      nodes.machine = common;

      testScript = ''
        machine.start()
        machine.wait_for_unit("multi-user.target")

        machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
        machine.succeed("grep 'sort-key nixos' /boot/loader/entries/nixos-generation-1.conf")

        # Ensure we actually booted using systemd-boot
        # Magic number is the vendor UUID used by systemd-boot.
        machine.succeed(
            "test -e /sys/firmware/efi/efivars/LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
        )

        # "bootctl install" should have created an EFI entry
        machine.succeed('efibootmgr | grep "Linux Boot Manager"')
      '';
    }
  );

  # Test that systemd-boot works with secure boot
  secureBoot = runTest (
    { pkgs, lib, ... }:
    {
      name = "systemd-boot-secure-boot";

      nodes.machine =
        { pkgs, ... }:
        {
          imports = [ common ];
          environment.systemPackages = [ pkgs.sbctl ];
          virtualisation.useSecureBoot = true;
        };

      testScript =
        { nodes, ... }:
        let
          efiArch = pkgs.stdenv.hostPlatform.efiArch;
        in
        ''
          machine.start(allow_reboot=True)
          machine.wait_for_unit("multi-user.target")

          machine.succeed("sbctl create-keys")
          machine.succeed("sbctl enroll-keys --yes-this-might-brick-my-machine")
          machine.succeed('sbctl sign /boot/EFI/systemd/systemd-boot${efiArch}.efi')
          machine.succeed('sbctl sign /boot/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI')
          machine.succeed('sbctl sign /boot/EFI/nixos/*${nodes.machine.system.boot.loader.kernelFile}.efi')

          machine.reboot()

          assert "Secure Boot: enabled (user)" in machine.succeed("bootctl status")
        '';
    }
  );

  basicXbootldr = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-xbootldr";
      meta.maintainers = with lib.maintainers; [ sdht0 ];

      nodes.machine = commonXbootldr;

      testScript =
        { nodes, ... }:
        ''
          ${customDiskImage nodes}

          machine.start()
          machine.wait_for_unit("multi-user.target")

          machine.succeed("test -e /efi/EFI/systemd/systemd-bootx64.efi")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")

          # Ensure we actually booted using systemd-boot
          # Magic number is the vendor UUID used by systemd-boot.
          machine.succeed(
              "test -e /sys/firmware/efi/efivars/LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
          )

          # "bootctl install" should have created an EFI entry
          machine.succeed('efibootmgr | grep "Linux Boot Manager"')
        '';
    }
  );

  # Check that specialisations create corresponding boot entries.
  specialisation = runTest (
    { pkgs, lib, ... }:
    {
      name = "systemd-boot-specialisation";
      meta.maintainers = with lib.maintainers; [
        lukegb
        julienmalka
      ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ common ];
          specialisation.something.configuration = {
            boot.loader.systemd-boot.sortKey = "something";

            # Since qemu will dynamically create a devicetree blob when starting
            # up, it is not straight forward to create an export of that devicetree
            # blob without knowing before-hand all the flags we would pass to qemu
            # (we would then be able to use `dumpdtb`). Thus, the following config
            # will not boot, but it does allow us to assert that the boot entry has
            # the correct contents.
            boot.loader.systemd-boot.installDeviceTree = pkgs.stdenv.hostPlatform.isAarch64;
            hardware.deviceTree.name = "dummy.dtb";
            hardware.deviceTree.package = lib.mkForce (
              pkgs.runCommand "dummy-devicetree-package" { } ''
                mkdir -p $out
                cp ${pkgs.emptyFile} $out/dummy.dtb
              ''
            );
          };
        };

      testScript =
        { nodes, ... }:
        ''
          machine.start()
          machine.wait_for_unit("multi-user.target")

          machine.succeed(
              "test -e /boot/loader/entries/nixos-generation-1-specialisation-something.conf"
          )
          machine.succeed(
              "grep -q 'title NixOS (something)' /boot/loader/entries/nixos-generation-1-specialisation-something.conf"
          )
          machine.succeed(
              "grep 'sort-key something' /boot/loader/entries/nixos-generation-1-specialisation-something.conf"
          )
        ''
        + pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isAarch64 ''
          machine.succeed(
              r"grep 'devicetree /EFI/nixos/[a-z0-9]\{32\}.*dummy' /boot/loader/entries/nixos-generation-1-specialisation-something.conf"
          )
        '';
    }
  );

  # Boot without having created an EFI entry--instead using default "/EFI/BOOT/BOOTX64.EFI"
  fallback = runTest (
    { pkgs, lib, ... }:
    {
      name = "systemd-boot-fallback";
      meta.maintainers = with lib.maintainers; [
        danielfullmer
        julienmalka
      ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ common ];
          boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
        };

      testScript = ''
        machine.start()
        machine.wait_for_unit("multi-user.target")

        machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")

        # Ensure we actually booted using systemd-boot
        # Magic number is the vendor UUID used by systemd-boot.
        machine.succeed(
            "test -e /sys/firmware/efi/efivars/LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
        )

        # "bootctl install" should _not_ have created an EFI entry
        machine.fail('efibootmgr | grep "Linux Boot Manager"')
      '';
    }
  );

  update = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-update";
      meta.maintainers = with lib.maintainers; [
        danielfullmer
        julienmalka
      ];

      nodes.machine = common;

      testScript = ''
        machine.succeed("mount -o remount,rw /boot")

        def switch():
            # Replace version inside sd-boot with something older. See magic[] string in systemd src/boot/efi/boot.c
            machine.succeed(
              """
              find /boot -iname '*boot*.efi' -print0 | \
              xargs -0 -I '{}' sed -i 's/#### LoaderInfo: systemd-boot .* ####/#### LoaderInfo: systemd-boot 000.0-1-notnixos ####/' '{}'
              """
            )
            return machine.succeed("/run/current-system/bin/switch-to-configuration boot 2>&1")

        output = switch()
        assert "updating systemd-boot from 000.0-1-notnixos to " in output, "Couldn't find systemd-boot update message"
        assert 'to "/boot/EFI/systemd/systemd-bootx64.efi"' in output, "systemd-boot not copied to to /boot/EFI/systemd/systemd-bootx64.efi"
        assert 'to "/boot/EFI/BOOT/BOOTX64.EFI"' in output, "systemd-boot not copied to to /boot/EFI/BOOT/BOOTX64.EFI"

        with subtest("Test that updating works with lowercase bootx64.efi"):
            machine.succeed(
                # Move to tmp file name first, otherwise mv complains the new location is the same
                "mv /boot/EFI/BOOT/BOOTX64.EFI /boot/EFI/BOOT/bootx64.efi.new",
                "mv /boot/EFI/BOOT/bootx64.efi.new /boot/EFI/BOOT/bootx64.efi",
            )
            output = switch()
            assert "updating systemd-boot from 000.0-1-notnixos to " in output, "Couldn't find systemd-boot update message"
            assert 'to "/boot/EFI/systemd/systemd-bootx64.efi"' in output, "systemd-boot not copied to to /boot/EFI/systemd/systemd-bootx64.efi"
            assert 'to "/boot/EFI/BOOT/BOOTX64.EFI"' in output, "systemd-boot not copied to to /boot/EFI/BOOT/BOOTX64.EFI"
      '';
    }
  );

  memtest86 = runTestOn [ "x86_64-linux" ] (
    { lib, ... }:
    {
      name = "systemd-boot-memtest86";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.memtest86.enable = true;
        };

      testScript = ''
        machine.succeed("test -e /boot/loader/entries/memtest86.conf")
        machine.succeed("test -e /boot/efi/memtest86/memtest.efi")
      '';
    }
  );

  netbootxyz = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-netbootxyz";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.netbootxyz.enable = true;
        };

      testScript = ''
        machine.succeed("test -e /boot/loader/entries/netbootxyz.conf")
        machine.succeed("test -e /boot/efi/netbootxyz/netboot.xyz.efi")
      '';
    }
  );

  edk2-uefi-shell = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-edk2-uefi-shell";
      meta.maintainers = with lib.maintainers; [ iFreilicht ];

      nodes.machine =
        { ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
        };

      testScript = ''
        machine.succeed("test -e /boot/loader/entries/edk2-uefi-shell.conf")
        machine.succeed("test -e /boot/efi/edk2-uefi-shell/shell.efi")
      '';
    }
  );

  windows = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-windows";
      meta.maintainers = with lib.maintainers; [ iFreilicht ];

      nodes.machine =
        { ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.windows = {
            "7" = {
              efiDeviceHandle = "HD0c1";
              sortKey = "before_all_others";
            };
            "Ten".efiDeviceHandle = "FS0";
            "11" = {
              title = "Title with-_-punctuation ...?!";
              efiDeviceHandle = "HD0d4";
              sortKey = "zzz";
            };
          };
        };

      testScript = ''
        machine.succeed("test -e /boot/efi/edk2-uefi-shell/shell.efi")

        machine.succeed("test -e /boot/loader/entries/windows_7.conf")
        machine.succeed("test -e /boot/loader/entries/windows_Ten.conf")
        machine.succeed("test -e /boot/loader/entries/windows_11.conf")

        machine.succeed("grep 'efi /efi/edk2-uefi-shell/shell.efi' /boot/loader/entries/windows_7.conf")
        machine.succeed("grep 'efi /efi/edk2-uefi-shell/shell.efi' /boot/loader/entries/windows_Ten.conf")
        machine.succeed("grep 'efi /efi/edk2-uefi-shell/shell.efi' /boot/loader/entries/windows_11.conf")

        machine.succeed("grep 'HD0c1:EFI\\\\Microsoft\\\\Boot\\\\Bootmgfw.efi' /boot/loader/entries/windows_7.conf")
        machine.succeed("grep 'FS0:EFI\\\\Microsoft\\\\Boot\\\\Bootmgfw.efi' /boot/loader/entries/windows_Ten.conf")
        machine.succeed("grep 'HD0d4:EFI\\\\Microsoft\\\\Boot\\\\Bootmgfw.efi' /boot/loader/entries/windows_11.conf")

        machine.succeed("grep 'sort-key before_all_others' /boot/loader/entries/windows_7.conf")
        machine.succeed("grep 'sort-key o_windows_Ten' /boot/loader/entries/windows_Ten.conf")
        machine.succeed("grep 'sort-key zzz' /boot/loader/entries/windows_11.conf")

        machine.succeed("grep 'title Windows 7' /boot/loader/entries/windows_7.conf")
        machine.succeed("grep 'title Windows Ten' /boot/loader/entries/windows_Ten.conf")
        machine.succeed('grep "title Title with-_-punctuation ...?!" /boot/loader/entries/windows_11.conf')
      '';
    }
  );

  memtestSortKey = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-memtest-sortkey";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.memtest86.enable = true;
          boot.loader.systemd-boot.memtest86.sortKey = "apple";
        };

      testScript = ''
        machine.succeed("test -e /boot/loader/entries/memtest86.conf")
        machine.succeed("test -e /boot/efi/memtest86/memtest.efi")
        machine.succeed("grep 'sort-key apple' /boot/loader/entries/memtest86.conf")
      '';
    }
  );

  entryFilenameXbootldr = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-entry-filename-xbootldr";
      meta.maintainers = with lib.maintainers; [ sdht0 ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ commonXbootldr ];
          boot.loader.systemd-boot.memtest86.enable = true;
        };

      testScript =
        { nodes, ... }:
        ''
          ${customDiskImage nodes}

          machine.start()
          machine.wait_for_unit("multi-user.target")

          machine.succeed("test -e /efi/EFI/systemd/systemd-bootx64.efi")
          machine.succeed("test -e /boot/loader/entries/memtest86.conf")
          machine.succeed("test -e /boot/EFI/memtest86/memtest.efi")
        '';
    }
  );

  extraEntries = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-extra-entries";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.extraEntries = {
            "banana.conf" = ''
              title banana
            '';
          };
        };

      testScript = ''
        machine.succeed("test -e /boot/loader/entries/banana.conf")
        machine.succeed("test -e /boot/efi/nixos/.extra-files/loader/entries/banana.conf")
      '';
    }
  );

  extraFiles = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-extra-files";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine =
        { pkgs, lib, ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.extraFiles = {
            "efi/fruits/tomato.efi" = pkgs.netbootxyz-efi;
          };
        };

      testScript = ''
        machine.succeed("test -e /boot/efi/fruits/tomato.efi")
        machine.succeed("test -e /boot/efi/nixos/.extra-files/efi/fruits/tomato.efi")
      '';
    }
  );

  switch-test = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-switch-test";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes = {
        inherit common;

        machine =
          { pkgs, nodes, ... }:
          {
            imports = [ common ];
            boot.loader.systemd-boot.extraFiles = {
              "efi/fruits/tomato.efi" = pkgs.netbootxyz-efi;
            };

            # These are configs for different nodes, but we'll use them here in `machine`
            system.extraDependencies = [
              nodes.common.system.build.toplevel
              nodes.with_netbootxyz.system.build.toplevel
            ];
          };

        with_netbootxyz =
          { pkgs, ... }:
          {
            imports = [ common ];
            boot.loader.systemd-boot.netbootxyz.enable = true;
          };
      };

      testScript =
        { nodes, ... }:
        let
          originalSystem = nodes.machine.system.build.toplevel;
          baseSystem = nodes.common.system.build.toplevel;
          finalSystem = nodes.with_netbootxyz.system.build.toplevel;
        in
        ''
          machine.succeed("test -e /boot/efi/fruits/tomato.efi")
          machine.succeed("test -e /boot/efi/nixos/.extra-files/efi/fruits/tomato.efi")

          with subtest("remove files when no longer needed"):
              machine.succeed("${baseSystem}/bin/switch-to-configuration boot")
              machine.fail("test -e /boot/efi/fruits/tomato.efi")
              machine.fail("test -d /boot/efi/fruits")
              machine.succeed("test -d /boot/efi/nixos/.extra-files")
              machine.fail("test -e /boot/efi/nixos/.extra-files/efi/fruits/tomato.efi")
              machine.fail("test -d /boot/efi/nixos/.extra-files/efi/fruits")

          with subtest("files are added back when needed again"):
              machine.succeed("${originalSystem}/bin/switch-to-configuration boot")
              machine.succeed("test -e /boot/efi/fruits/tomato.efi")
              machine.succeed("test -e /boot/efi/nixos/.extra-files/efi/fruits/tomato.efi")

          with subtest("simultaneously removing and adding files works"):
              machine.succeed("${finalSystem}/bin/switch-to-configuration boot")
              machine.fail("test -e /boot/efi/fruits/tomato.efi")
              machine.fail("test -e /boot/efi/nixos/.extra-files/efi/fruits/tomato.efi")
              machine.succeed("test -e /boot/loader/entries/netbootxyz.conf")
              machine.succeed("test -e /boot/efi/netbootxyz/netboot.xyz.efi")
              machine.succeed("test -e /boot/efi/nixos/.extra-files/loader/entries/netbootxyz.conf")
              machine.succeed("test -e /boot/efi/nixos/.extra-files/efi/netbootxyz/netboot.xyz.efi")
        '';
    }
  );

  garbage-collect-entry = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-garbage-collect-entry";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes = {
        inherit common;
        machine =
          { pkgs, nodes, ... }:
          {
            imports = [ common ];

            # These are configs for different nodes, but we'll use them here in `machine`
            system.extraDependencies = [
              nodes.common.system.build.toplevel
            ];
          };
      };

      testScript =
        { nodes, ... }:
        let
          baseSystem = nodes.common.system.build.toplevel;
        in
        ''
          machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${baseSystem}")
          machine.succeed("nix-env -p /nix/var/nix/profiles/system --delete-generations 1")
          machine.succeed("${baseSystem}/bin/switch-to-configuration boot")
          machine.fail("test -e /boot/loader/entries/nixos-generation-1.conf")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-2.conf")
        '';
    }
  );

  no-bootspec = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-no-bootspec";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine = {
        imports = [ common ];
        boot.bootspec.enable = false;
      };

      testScript = ''
        machine.start()
        machine.wait_for_unit("multi-user.target")
      '';
    }
  );
}

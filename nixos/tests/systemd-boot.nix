{
  runTest,
  runTestOn,
  lib,
  ...
}:

let
  testScriptPreamble =
    # python
    ''
      def check_current_system(system_path):
          machine.succeed(f'test $(readlink -f /run/current-system) = "{system_path}"')

      def check_generation(generation: int, tries_left=0, tries_failed=0, specialisation=None) -> list[str]:
          if specialisation:
              title = f"NixOS ({specialisation})"
          else:
              title = "NixOS"

          conf_files = machine.succeed(
              f"grep --files-with-matches 'version Generation {generation} NixOS' /boot/loader/entries/nixos-*.conf | xargs grep --line-regexp --fixed-strings --files-with-matches 'title {title}'"
          ).split("\n")

          suffix = ""
          if tries_left:
              suffix += f"+{tries_left}"
          if tries_failed:
              suffix += f"-{tries_failed}"

          assert conf_files[0].endswith(f"{suffix}.conf"), f"Expected {conf_files[0]} to end with {suffix}.conf"
          return conf_files
    '';

  common =
    { pkgs, ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      environment.systemPackages = [ pkgs.efibootmgr ];
      system.switch.enable = true;
      # Needed for machine-id to be persisted between reboots
      environment.etc."machine-id".text = "00000000000000000000000000000000";
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

  customDiskImage =
    nodes:
    # python
    ''
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

  # Check that we are booting the default entry and not the generation with largest version number
  defaultEntry =
    {
      lib,
      pkgs,
      withBootCounting ? false,
      ...
    }:
    runTest {
      name = "systemd-boot-default-entry" + lib.optionalString withBootCounting "-with-boot-counting";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes = {
        machine =
          { nodes, ... }:
          {
            imports = [ common ];
            system.extraDependencies = [ nodes.other_machine.system.build.toplevel ];
            boot.loader.systemd-boot.bootCounting.enable = withBootCounting;
          };

        other_machine = {
          imports = [ common ];
          boot.loader.systemd-boot.bootCounting.enable = withBootCounting;
          environment.systemPackages = [ pkgs.hello ];
        };
      };
      testScript =
        { nodes, ... }:
        let
          orig = nodes.machine.system.build.toplevel;
          other = nodes.other_machine.system.build.toplevel;
        in
        # python
        ''
          orig = "${orig}"
          other = "${other}"

          check_current_system(orig)

          # Switch to other configuration
          machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${other}")
          machine.succeed(f"{other}/bin/switch-to-configuration boot")
          # Rollback, default entry is now generation 1
          machine.succeed("nix-env -p /nix/var/nix/profiles/system --rollback")
          machine.succeed(f"{orig}/bin/switch-to-configuration boot")
          machine.shutdown()
          machine.start()
          machine.wait_for_unit("multi-user.target")
          # Check that we booted generation 1 (default)
          # even though generation 2 comes first in alphabetical order
          check_current_system(orig)
        '';
    };

  garbage-collect-entry =
    {
      withBootCounting ? false,
      ...
    }:
    runTest (
      { lib, ... }:
      {
        name =
          "systemd-boot-garbage-collect-entry" + lib.optionalString withBootCounting "-with-boot-counting";
        meta.maintainers = with lib.maintainers; [ julienmalka ];

        nodes = {
          inherit common;
          machine =
            { nodes, ... }:
            {
              imports = [ common ];

              boot.loader.systemd-boot.bootCounting.enable = withBootCounting;
              boot.loader.systemd-boot.memtest86.enable = true;

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
          # python
          ''
            ${testScriptPreamble}

            machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${baseSystem}")
            machine.succeed("nix-env -p /nix/var/nix/profiles/system --delete-generations 1")

            conf_file = check_generation(1)[0]
            new_conf_file = conf_file.replace(".conf", "-1+3.conf")

            # At this point generation 1 has already been marked as good so we reintroduce counters artificially
            ${lib.optionalString withBootCounting ''
              machine.succeed(f"mv {conf_file} {new_conf_file}")
            ''}
            machine.succeed("${baseSystem}/bin/switch-to-configuration boot")
            machine.fail(
              "grep --files-with-matches 'version Generation 1 NixOS' /boot/loader/entries/nixos-*.conf"
            )
            check_generation(2)
          '';
      }
    );
in
{
  inherit defaultEntry garbage-collect-entry;

  basic = runTest (
    { lib, ... }:
    {
      name = "systemd-boot";
      meta.maintainers = with lib.maintainers; [
        danielfullmer
        julienmalka
      ];

      nodes.machine = common;

      testScript = # python
        ''
          ${testScriptPreamble}

          machine.start()
          machine.wait_for_unit("multi-user.target")

          conf_file = check_generation(1)[0]

          machine.succeed(f"grep 'sort-key nixos' {conf_file}")

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
        #python
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
        #python
        ''
          ${testScriptPreamble}

          ${customDiskImage nodes}

          machine.start()
          machine.wait_for_unit("multi-user.target")

          machine.succeed("test -e /efi/EFI/systemd/systemd-bootx64.efi")
          check_generation(1)

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
        # python
        ''
          ${testScriptPreamble}

          machine.start()
          machine.wait_for_unit("multi-user.target")

          conf_files = check_generation(1, specialisation="something")
          machine.succeed(
              f"grep --fixed-strings --line-regexp 'sort-key something' {" ".join(conf_files)}"
          )

          ${lib.optionalString pkgs.stdenv.hostPlatform.isAarch64
            #python
            ''
              machine.succeed(
                  fr"grep 'devicetree /EFI/nixos/[a-z0-9]\{32\}.*dummy' {" ".join(conf_files)}"
              )
            ''
          }
        '';
    }
  );

  # Boot without having created an EFI entry--instead using default "/EFI/BOOT/BOOTX64.EFI"
  fallback = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-fallback";
      meta.maintainers = with lib.maintainers; [
        danielfullmer
        julienmalka
      ];

      nodes.machine =
        { lib, ... }:
        {
          imports = [ common ];
          boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
        };

      testScript =
        # python
        ''
          ${testScriptPreamble}

          machine.start()
          machine.wait_for_unit("multi-user.target")

          check_generation(1)

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

      testScript =
        # python
        ''
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

      nodes.machine = {
        imports = [ common ];
        boot.loader.systemd-boot.memtest86.enable = true;
      };

      testScript =
        # python
        ''
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

      nodes.machine = {
        imports = [ common ];
        boot.loader.systemd-boot.netbootxyz.enable = true;
      };

      testScript =
        # python
        ''
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

      testScript =
        # python
        ''
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

      testScript =
        # python
        ''
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

      nodes.machine = {
        imports = [ common ];
        boot.loader.systemd-boot.memtest86.enable = true;
        boot.loader.systemd-boot.memtest86.sortKey = "apple";
      };

      testScript =
        # python
        ''
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

      nodes.machine = {
        imports = [ commonXbootldr ];
        boot.loader.systemd-boot.memtest86.enable = true;
      };

      testScript =
        { nodes, ... }:
        # python
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

      nodes.machine = {
        imports = [ common ];
        boot.loader.systemd-boot.extraEntries = {
          "banana.conf" = ''
            title banana
          '';
        };
      };

      testScript =
        # python
        ''
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
        { pkgs, ... }:
        {
          imports = [ common ];
          boot.loader.systemd-boot.extraFiles = {
            "efi/fruits/tomato.efi" = pkgs.netbootxyz-efi;
          };
        };

      testScript =
        # python
        ''
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

        with_netbootxyz = {
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
        # python
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

  no-bootspec = runTest (
    { lib, ... }:
    {
      name = "systemd-boot-no-bootspec";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine = {
        imports = [ common ];
        boot.bootspec.enable = false;
      };

      testScript =
        # python
        ''
          machine.start()
          machine.wait_for_unit("multi-user.target")
        '';
    }
  );

  bootCounting =
    let
      baseConfig = {
        imports = [ common ];

        boot.loader.systemd-boot.bootCounting = {
          enable = true;
          tries = 2;
        };
      };
    in
    runTest {
      name = "systemd-boot-counting";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes = {
        machine =
          { nodes, ... }:
          {
            imports = [ baseConfig ];
            system.extraDependencies = [
              nodes.bad_machine.system.build.toplevel
              nodes.unused_machine.system.build.toplevel
            ];
          };

        unused_machine =
          { nodes, ... }:
          {
            imports = [ baseConfig ];
          };

        bad_machine = {
          imports = [ baseConfig ];

          systemd.services."failing" = {
            script = "exit 1";
            requiredBy = [ "boot-complete.target" ];
            before = [ "boot-complete.target" ];
            serviceConfig.Type = "oneshot";
          };
        };
      };
      testScript =
        { nodes, ... }:
        let
          orig = nodes.machine.system.build.toplevel;
          bad = nodes.bad_machine.system.build.toplevel;
          unused = nodes.unused_machine.system.build.toplevel;
        in
        # python
        ''
          ${testScriptPreamble}

          orig = "${orig}"
          bad = "${bad}"

          machine.start(allow_reboot=True)

          # Ensure we booted using an entry with counters enabled
          machine.succeed(
              "test -e /sys/firmware/efi/efivars/LoaderBootCountPath-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
          )

          # systemd-bless-boot should have already removed the "+2" suffix from the boot entry
          machine.wait_for_unit("systemd-bless-boot.service")
          conf_file = check_generation(1)
          check_current_system(orig)

          print(machine.succeed("cat /boot/loader/entries/*.conf"))

          # Switch to bad configuration
          machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${bad}")
          # TODO: for some reason, systemd-boot in our test setup is not respecting
          # the default boot order as configured in the EFI vars.
          # This does work correctly in practice outside of the test framework though.
          #machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${unused}")
          machine.succeed(f"{bad}/bin/switch-to-configuration boot")

          # Ensure new bootloader entry has initialized counter
          check_generation(1)
          check_generation(2, 2)

          machine.reboot()

          machine.wait_for_unit("multi-user.target")
          check_current_system(bad)
          check_generation(1)
          check_generation(2, 1, 1)

          machine.reboot()

          machine.wait_for_unit("multi-user.target")
          check_current_system(bad)
          check_generation(1)
          check_generation(2, 0, 2)

          machine.reboot()

          machine.wait_for_unit("multi-user.target")
          # Should boot back into original configuration
          check_current_system(orig)
          check_generation(1)
          check_generation(2, 0, 2)
        '';
    };

  bootCountingSpecialisation =
    let
      baseConfig = {
        imports = [ common ];
        boot.loader.systemd-boot.bootCounting = {
          enable = true;
          tries = 2;
        };
      };

      specialisationName = "+something+-+that+-+breaks-parsing+-+";
    in
    runTest {
      name = "systemd-boot-counting-specialisation";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes = {
        machine =
          { nodes, lib, ... }:
          {
            imports = [ baseConfig ];
            specialisation.${specialisationName}.configuration = {
              boot.loader.systemd-boot.sortKey = "something";
            };
          };
      };
      testScript =
        { nodes, ... }:
        let
          orig = nodes.machine.system.build.toplevel;
        in
        # python
        ''
          ${testScriptPreamble}

          orig = "${orig}"

          # Ensure we booted using an entry with counters enabled
          machine.succeed(
              "test -e /sys/firmware/efi/efivars/LoaderBootCountPath-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
          )

          check_generation(1)
          check_current_system(orig)

          # Ensure the bootloader entry for the specialisation has initialized the boot counter
          check_generation(1, 2, specialisation="${specialisationName}")
        '';
    };

  defaultEntryWithBootCounting =
    { lib, pkgs }:
    defaultEntry {
      inherit lib pkgs;
      withBootCounting = true;
    };

  garbageCollectEntryWithBootCounting = garbage-collect-entry { withBootCounting = true; };
}

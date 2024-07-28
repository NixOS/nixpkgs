{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  common = {
    virtualisation.useBootLoader = true;
    virtualisation.useEFIBoot = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    environment.systemPackages = [ pkgs.efibootmgr ];
    # Needed for machine-id to be persisted between reboots
    environment.etc."machine-id".text = "00000000000000000000000000000000";
  };

  commonXbootldr = { config, lib, pkgs, ... }:
    let
      diskImage = import ../lib/make-disk-image.nix {
        inherit config lib pkgs;
        label = "nixos";
        format = "qcow2";
        partitionTableType = "efixbootldr";
        touchEFIVars = true;
        installBootLoader = true;
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
rec {
  basic = makeTest {
    name = "systemd-boot";
    meta.maintainers = with pkgs.lib.maintainers; [ danielfullmer julienmalka ];

    nodes.machine = common;

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
      # our sort-key will uses r to sort before nixos
      machine.succeed("grep 'sort-key nixor-default' /boot/loader/entries/nixos-generation-1.conf")

      # Ensure we actually booted using systemd-boot
      # Magic number is the vendor UUID used by systemd-boot.
      machine.succeed(
          "test -e /sys/firmware/efi/efivars/LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
      )

      # "bootctl install" should have created an EFI entry
      machine.succeed('efibootmgr | grep "Linux Boot Manager"')
    '';
  };

  # Test that systemd-boot works with secure boot
  secureBoot = makeTest {
    name = "systemd-boot-secure-boot";

    nodes.machine = {
      imports = [ common ];
      environment.systemPackages = [ pkgs.sbctl ];
      virtualisation.useSecureBoot = true;
    };

    testScript = let
      efiArch = pkgs.stdenv.hostPlatform.efiArch;
    in { nodes, ... }: ''
      machine.start(allow_reboot=True)
      machine.wait_for_unit("multi-user.target")

      machine.succeed("sbctl create-keys")
      machine.succeed("sbctl enroll-keys --yes-this-might-brick-my-machine")
      machine.succeed('sbctl sign /boot/EFI/systemd/systemd-boot${efiArch}.efi')
      machine.succeed('sbctl sign /boot/EFI/BOOT/BOOT${toUpper efiArch}.EFI')
      machine.succeed('sbctl sign /boot/EFI/nixos/*${nodes.machine.system.boot.loader.kernelFile}.efi')

      machine.reboot()

      assert "Secure Boot: enabled (user)" in machine.succeed("bootctl status")
    '';
  };

  basicXbootldr = makeTest {
    name = "systemd-boot-xbootldr";
    meta.maintainers = with pkgs.lib.maintainers; [ sdht0 ];

    nodes.machine = commonXbootldr;

    testScript = { nodes, ... }: ''
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
  };

  # Check that specialisations create corresponding boot entries.
  specialisation = makeTest {
    name = "systemd-boot-specialisation";
    meta.maintainers = with pkgs.lib.maintainers; [ lukegb julienmalka ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      specialisation.something.configuration = {
        boot.loader.systemd-boot.sortKey = "something";
      };
    };

    testScript = ''
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
    '';
  };

  # Boot without having created an EFI entry--instead using default "/EFI/BOOT/BOOTX64.EFI"
  fallback = makeTest {
    name = "systemd-boot-fallback";
    meta.maintainers = with pkgs.lib.maintainers; [ danielfullmer julienmalka ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.efi.canTouchEfiVariables = mkForce false;
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
  };

  update = makeTest {
    name = "systemd-boot-update";
    meta.maintainers = with pkgs.lib.maintainers; [ danielfullmer julienmalka ];

    nodes.machine = common;

    testScript = ''
      machine.succeed("mount -o remount,rw /boot")

      # Replace version inside sd-boot with something older. See magic[] string in systemd src/boot/efi/boot.c
      machine.succeed(
          """
        find /boot -iname '*boot*.efi' -print0 | \
        xargs -0 -I '{}' sed -i 's/#### LoaderInfo: systemd-boot .* ####/#### LoaderInfo: systemd-boot 000.0-1-notnixos ####/' '{}'
      """
      )

      output = machine.succeed("/run/current-system/bin/switch-to-configuration boot 2>&1")
      assert "updating systemd-boot from 000.0-1-notnixos to " in output, "Couldn't find systemd-boot update message"
      assert 'to "/boot/EFI/systemd/systemd-bootx64.efi"' in output, "systemd-boot not copied to to /boot/EFI/systemd/systemd-bootx64.efi"
      assert 'to "/boot/EFI/BOOT/BOOTX64.EFI"' in output, "systemd-boot not copied to to /boot/EFI/BOOT/BOOTX64.EFI"
    '';
  };

  memtest86 = makeTest {
    name = "systemd-boot-memtest86";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.memtest86.enable = true;
    };

    testScript = ''
      machine.succeed("test -e /boot/loader/entries/memtest86.conf")
      machine.succeed("test -e /boot/efi/memtest86/memtest.efi")
    '';
  };

  netbootxyz = makeTest {
    name = "systemd-boot-netbootxyz";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.netbootxyz.enable = true;
    };

    testScript = ''
      machine.succeed("test -e /boot/loader/entries/netbootxyz.conf")
      machine.succeed("test -e /boot/efi/netbootxyz/netboot.xyz.efi")
    '';
  };

  memtestSortKey = makeTest {
    name = "systemd-boot-memtest-sortkey";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.memtest86.enable = true;
      boot.loader.systemd-boot.memtest86.sortKey = "apple";
    };

    testScript = ''
      machine.succeed("test -e /boot/loader/entries/memtest86.conf")
      machine.succeed("test -e /boot/efi/memtest86/memtest.efi")
      machine.succeed("grep 'sort-key apple' /boot/loader/entries/memtest86.conf")
    '';
  };

  entryFilenameXbootldr = makeTest {
    name = "systemd-boot-entry-filename-xbootldr";
    meta.maintainers = with pkgs.lib.maintainers; [ sdht0 ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ commonXbootldr ];
      boot.loader.systemd-boot.memtest86.enable = true;
    };

    testScript = { nodes, ... }: ''
      ${customDiskImage nodes}

      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /efi/EFI/systemd/systemd-bootx64.efi")
      machine.succeed("test -e /boot/loader/entries/memtest86.conf")
      machine.succeed("test -e /boot/EFI/memtest86/memtest.efi")
    '';
  };

  extraEntries = makeTest {
    name = "systemd-boot-extra-entries";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes.machine = { pkgs, lib, ... }: {
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
  };

  extraFiles = makeTest {
    name = "systemd-boot-extra-files";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.extraFiles = {
        "efi/fruits/tomato.efi" = pkgs.netbootxyz-efi;
      };
    };

    testScript = ''
      machine.succeed("test -e /boot/efi/fruits/tomato.efi")
      machine.succeed("test -e /boot/efi/nixos/.extra-files/efi/fruits/tomato.efi")
    '';
  };

  switch-test = makeTest {
    name = "systemd-boot-switch-test";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes = {
      inherit common;

      machine = { pkgs, nodes, ... }: {
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

      with_netbootxyz = { pkgs, ... }: {
        imports = [ common ];
        boot.loader.systemd-boot.netbootxyz.enable = true;
      };
    };

    testScript = { nodes, ... }: let
      originalSystem = nodes.machine.system.build.toplevel;
      baseSystem = nodes.common.system.build.toplevel;
      finalSystem = nodes.with_netbootxyz.system.build.toplevel;
    in ''
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
  };

  garbage-collect-entry = { withBootCounting ? false, ... }: makeTest {
    name = "systemd-boot-garbage-collect-entry" + optionalString withBootCounting "-with-boot-counting";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes = {
      inherit common;
      machine = { pkgs, nodes, ... }: {
        imports = [ common ];
        boot.loader.systemd-boot.bootCounting.enable = withBootCounting;
        # These are configs for different nodes, but we'll use them here in `machine`
        system.extraDependencies = [
          nodes.common.system.build.toplevel
        ];
      };
    };

    testScript = { nodes, ... }:
      let
        baseSystem = nodes.common.system.build.toplevel;
      in
      ''
        machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${baseSystem}")
        machine.succeed("nix-env -p /nix/var/nix/profiles/system --delete-generations 1")
        # At this point generation 1 has already been marked as good so we reintroduce counters artificially
        ${optionalString withBootCounting ''
        machine.succeed("mv /boot/loader/entries/nixos-generation-1.conf /boot/loader/entries/nixos-generation-1+3.conf")
        ''}
        machine.succeed("${baseSystem}/bin/switch-to-configuration boot")
        machine.fail("test -e /boot/loader/entries/nixos-generation-1*")
        machine.succeed("test -e /boot/loader/entries/nixos-generation-2.conf")
      '';
  };

  no-bootspec = makeTest
    {
      name = "systemd-boot-no-bootspec";
      meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

      nodes.machine = {
        imports = [ common ];
        boot.bootspec.enable = false;
      };

      testScript = ''
        machine.start()
        machine.wait_for_unit("multi-user.target")
      '';
    };

  # Check that we are booting the default entry and not the generation with largest version number
  defaultEntry = { withBootCounting ? false, ... }: makeTest {
    name = "systemd-boot-default-entry" + optionalString withBootCounting "-with-boot-counting";
    meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

    nodes = {
      machine = { pkgs, lib, nodes, ... }: {
        imports = [ common ];
        system.extraDependencies = [ nodes.other_machine.system.build.toplevel ];
        boot.loader.systemd-boot.bootCounting.enable = withBootCounting;
      };

      other_machine = { pkgs, lib, ... }: {
        imports = [ common ];
        boot.loader.systemd-boot.bootCounting.enable = withBootCounting;
        environment.systemPackages = [ pkgs.hello ];
      };
    };
    testScript = { nodes, ... }:
      let
        orig = nodes.machine.system.build.toplevel;
        other = nodes.other_machine.system.build.toplevel;
      in
      ''
        orig = "${orig}"
        other = "${other}"

        def check_current_system(system_path):
            machine.succeed(f'test $(readlink -f /run/current-system) = "{system_path}"')

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


  bootCounting =
    let
      baseConfig = { pkgs, lib, ... }: {
        imports = [ common ];
        boot.loader.systemd-boot.bootCounting.enable = true;
        boot.loader.systemd-boot.bootCounting.trials = 2;
      };
    in
    makeTest {
      name = "systemd-boot-counting";
      meta.maintainers = with pkgs.lib.maintainers; [ julienmalka ];

      nodes = {
        machine = { pkgs, lib, nodes, ... }: {
          imports = [ baseConfig ];
          system.extraDependencies = [ nodes.bad_machine.system.build.toplevel ];
        };

        bad_machine = { pkgs, lib, ... }: {
          imports = [ baseConfig ];

          systemd.services."failing" = {
            script = "exit 1";
            requiredBy = [ "boot-complete.target" ];
            before = [ "boot-complete.target" ];
            serviceConfig.Type = "oneshot";
          };
        };
      };
      testScript = { nodes, ... }:
        let
          orig = nodes.machine.system.build.toplevel;
          bad = nodes.bad_machine.system.build.toplevel;
        in
        ''
          orig = "${orig}"
          bad = "${bad}"

          def check_current_system(system_path):
              machine.succeed(f'test $(readlink -f /run/current-system) = "{system_path}"')

          # Ensure we booted using an entry with counters enabled
          machine.succeed(
              "test -e /sys/firmware/efi/efivars/LoaderBootCountPath-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
          )

          # systemd-bless-boot should have already removed the "+2" suffix from the boot entry
          machine.wait_for_unit("systemd-bless-boot.service")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
          check_current_system(orig)

          # Switch to bad configuration
          machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${bad}")
          machine.succeed(f"{bad}/bin/switch-to-configuration boot")

          # Ensure new bootloader entry has initialized counter
          machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-2+2.conf")
          machine.shutdown()

          machine.start()
          machine.wait_for_unit("multi-user.target")
          check_current_system(bad)
          machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-2+1-1.conf")
          machine.shutdown()

          machine.start()
          machine.wait_for_unit("multi-user.target")
          check_current_system(bad)
          machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-2+0-2.conf")
          machine.shutdown()

          # Should boot back into original configuration
          machine.start()
          check_current_system(orig)
          machine.wait_for_unit("multi-user.target")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
          machine.succeed("test -e /boot/loader/entries/nixos-generation-2+0-2.conf")
          machine.shutdown()
        '';
    };
  defaultEntryWithBootCounting = defaultEntry { withBootCounting = true; };
  garbageCollectEntryWithBootCounting = garbage-collect-entry { withBootCounting = true; };
}

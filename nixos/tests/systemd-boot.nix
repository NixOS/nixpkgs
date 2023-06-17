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
  };
in
{
  basic = makeTest {
    name = "systemd-boot";
    meta.maintainers = with pkgs.lib.maintainers; [ danielfullmer ];

    nodes.machine = common;

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

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
    meta.maintainers = with pkgs.lib.maintainers; [ lukegb ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      specialisation.something.configuration = {};
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
    '';
  };

  # Boot without having created an EFI entry--instead using default "/EFI/BOOT/BOOTX64.EFI"
  fallback = makeTest {
    name = "systemd-boot-fallback";
    meta.maintainers = with pkgs.lib.maintainers; [ danielfullmer ];

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
    meta.maintainers = with pkgs.lib.maintainers; [ danielfullmer ];

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

      output = machine.succeed("/run/current-system/bin/switch-to-configuration boot")
      assert "updating systemd-boot from 000.0-1-notnixos to " in output
    '';
  };

  memtest86 = makeTest {
    name = "systemd-boot-memtest86";
    meta.maintainers = with pkgs.lib.maintainers; [ Enzime ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.memtest86.enable = true;
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "memtest86-efi"
      ];
    };

    testScript = ''
      machine.succeed("test -e /boot/loader/entries/memtest86.conf")
      machine.succeed("test -e /boot/efi/memtest86/BOOTX64.efi")
    '';
  };

  netbootxyz = makeTest {
    name = "systemd-boot-netbootxyz";
    meta.maintainers = with pkgs.lib.maintainers; [ Enzime ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.netbootxyz.enable = true;
    };

    testScript = ''
      machine.succeed("test -e /boot/loader/entries/o_netbootxyz.conf")
      machine.succeed("test -e /boot/efi/netbootxyz/netboot.xyz.efi")
    '';
  };

  entryFilename = makeTest {
    name = "systemd-boot-entry-filename";
    meta.maintainers = with pkgs.lib.maintainers; [ Enzime ];

    nodes.machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.memtest86.enable = true;
      boot.loader.systemd-boot.memtest86.entryFilename = "apple.conf";
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "memtest86-efi"
      ];
    };

    testScript = ''
      machine.fail("test -e /boot/loader/entries/memtest86.conf")
      machine.succeed("test -e /boot/loader/entries/apple.conf")
      machine.succeed("test -e /boot/efi/memtest86/BOOTX64.efi")
    '';
  };

  extraEntries = makeTest {
    name = "systemd-boot-extra-entries";
    meta.maintainers = with pkgs.lib.maintainers; [ Enzime ];

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
    meta.maintainers = with pkgs.lib.maintainers; [ Enzime ];

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
    meta.maintainers = with pkgs.lib.maintainers; [ Enzime ];

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
          machine.succeed("test -e /boot/loader/entries/o_netbootxyz.conf")
          machine.succeed("test -e /boot/efi/netbootxyz/netboot.xyz.efi")
          machine.succeed("test -e /boot/efi/nixos/.extra-files/loader/entries/o_netbootxyz.conf")
          machine.succeed("test -e /boot/efi/nixos/.extra-files/efi/netbootxyz/netboot.xyz.efi")
    '';
  };

  # Some UEFI firmwares fail on large reads. Now that systemd-boot loads initrd
  # itself, systems with such firmware won't boot without this fix
  uefiLargeFileWorkaround = makeTest {
    name = "uefi-large-file-workaround";

    nodes.machine = { pkgs, ... }: {
      imports = [common];
      virtualisation.efi.OVMF = pkgs.OVMF.overrideAttrs (old: {
        # This patch deliberately breaks the FAT driver in EDK2 to
        # exhibit (part of) the firmware bug that we are testing
        # for. Files greater than 10MiB will fail to be read in a
        # single Read() call, so systemd-boot will fail to load the
        # initrd without a workaround. The number 10MiB was chosen
        # because if it were smaller than the kernel size, even the
        # LoadImage call would fail, which is not the failure mode
        # we're testing for. It needs to be between the kernel size
        # and the initrd size.
        patches = old.patches or [] ++ [ ./systemd-boot-ovmf-broken-fat-driver.patch ];
      });
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
    '';
  };
}

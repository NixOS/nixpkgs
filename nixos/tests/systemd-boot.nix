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
    meta.maintainers = with pkgs.stdenv.lib.maintainers; [ danielfullmer ];

    machine = common;

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /boot/loader/entries/nixos-generation-default-1.conf")

      # Ensure we actually booted using systemd-boot
      # Magic number is the vendor UUID used by systemd-boot.
      machine.succeed(
          "test -e /sys/firmware/efi/efivars/LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
      )

      # "bootctl install" should have created an EFI entry
      machine.succeed('efibootmgr | grep "Linux Boot Manager"')
    '';
  };

  # Boot without having created an EFI entry--instead using default "/EFI/BOOT/BOOTX64.EFI"
  fallback = makeTest {
    name = "systemd-boot-fallback";
    meta.maintainers = with pkgs.stdenv.lib.maintainers; [ danielfullmer ];

    machine = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.efi.canTouchEfiVariables = mkForce false;
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("test -e /boot/loader/entries/nixos-generation-default-1.conf")

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
    meta.maintainers = with pkgs.stdenv.lib.maintainers; [ danielfullmer ];

    machine = common;

    testScript = ''
      machine.succeed("mount -o remount,rw /boot")

      # Replace version inside sd-boot with something older. See magic[] string in systemd src/boot/efi/boot.c
      machine.succeed(
          """
        find /boot -iname '*.efi' -print0 | \
        xargs -0 -I '{}' sed -i 's/#### LoaderInfo: systemd-boot .* ####/#### LoaderInfo: systemd-boot 001 ####/' '{}'
      """
      )

      output = machine.succeed("/run/current-system/bin/switch-to-configuration boot")
      assert "updating systemd-boot from 001 to " in output
    '';
  };

  bootCounters = let
    baseConfig = { pkgs, lib, ... }: {
      imports = [ common ];
      boot.loader.systemd-boot.counters.enable = true;
      boot.loader.systemd-boot.counters.tries = 2;
    };
  in makeTest {
    name = "systemd-boot-counters";
    nodes = {
      machine = { pkgs, lib, ... }: {
        imports = [ baseConfig ];
      };

      bad = { pkgs, lib, ...}: {
        imports = [ baseConfig ];

        systemd.services."failing" = {
          script = "exit 1";
          requiredBy = [ "boot-complete.target" ];
          before = [ "boot-complete.target" ];
          serviceConfig.Type = "oneshot";
        };
      };
    };
    testScript = { nodes, ... }: let
      orig = nodes.machine.config.system.build.toplevel;
      bad = nodes.bad.config.system.build.toplevel;
    in ''
      # fmt: off
      orig = "${orig}"
      bad = "${bad}"
      # fmt: on


      def check_current_system(system_path):
          machine.succeed(f'test $(readlink -f /run/current-system) = "{system_path}"')


      # Ensure we booted using an entry with counters enabled
      machine.succeed(
          "test -e /sys/firmware/efi/efivars/LoaderBootCountPath-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
      )

      # systemd-bless-boot should have already removed the "+2" suffix from the boot entry
      machine.wait_for_unit("systemd-bless-boot.service")
      machine.succeed("test -e /boot/loader/entries/nixos-generation-default-1.conf")
      check_current_system(orig)

      # Switch to bad configuration
      machine.succeed(
          "ln -s $(readlink -f /run/current-system) /nix/var/nix/profiles/system-1-link",
          "ln -s /nix/var/nix/profiles/system-1-link /nix/var/nix/profiles/system",
          f"ln -s {bad} /nix/var/nix/profiles/system-2-link",
          f"{bad}/bin/switch-to-configuration boot",
      )

      # Ensure new bootloader entry has initialized counter
      machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
      machine.succeed("test -e /boot/loader/entries/nixos-generation-default-2+2.conf")
      machine.shutdown()

      machine.start()
      machine.wait_for_unit("multi-user.target")
      check_current_system(bad)
      machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
      machine.succeed("test -e /boot/loader/entries/nixos-generation-default-2+1-1.conf")
      machine.shutdown()

      machine.start()
      machine.wait_for_unit("multi-user.target")
      check_current_system(bad)
      machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
      machine.succeed("test -e /boot/loader/entries/nixos-generation-default-2+0-2.conf")
      machine.shutdown()

      # Should boot back into original configuration
      machine.start()
      check_current_system(orig)
      machine.wait_for_unit("multi-user.target")
      machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")
      machine.succeed("test -e /boot/loader/entries/nixos-generation-default-2+0-2.conf")
      machine.shutdown()
    '';
  };
}

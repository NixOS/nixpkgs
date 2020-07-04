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

      machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")

      # Ensure we actually booted using systemd-boot
      # Magic number is the vendor UUID used by systemd-boot.
      machine.succeed(
          "test -e /sys/firmware/efi/efivars/LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
      )
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
}

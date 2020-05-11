{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

makeTest {
  name = "systemd-boot";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ danielfullmer ];

  machine = { pkgs, lib, ... }: {
    virtualisation.useBootLoader = true;
    virtualisation.useEFIBoot = true;
    boot.loader.systemd-boot.enable = true;
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    machine.succeed("test -e /boot/loader/entries/nixos-generation-1.conf")

    # Ensure we actually booted using systemd-boot.
    # Magic number is the vendor UUID used by systemd-boot.
    machine.succeed(
        "test -e /sys/firmware/efi/efivars/LoaderEntrySelected-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f"
    )
  '';
}

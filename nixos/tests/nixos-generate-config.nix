{ lib, ... }:
{
  name = "nixos-generate-config";
  meta.maintainers = with lib.maintainers; [ basvandijk ];
  nodes.machine = {
    system.nixos-generate-config.configuration = ''
      # OVERRIDDEN
      { config, pkgs, ... }: {
        imports = [ ./hardware-configuration.nix ];
      $bootLoaderConfig
      $desktopConfiguration
      }
    '';

    system.nixos-generate-config.desktopConfiguration = [
      ''
        # DESKTOP
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = true;
      ''
    ];
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("nixos-generate-config")

    machine.succeed("nix-instantiate --parse /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix")

    # Test if the configuration really is overridden
    machine.succeed("grep 'OVERRIDDEN' /etc/nixos/configuration.nix")

    # Test if desktop configuration really is overridden
    machine.succeed("grep 'DESKTOP' /etc/nixos/configuration.nix")

    # Test of if the Perl variable $bootLoaderConfig is spliced correctly:
    machine.succeed(
        "grep 'boot\\.loader\\.grub\\.enable = true;' /etc/nixos/configuration.nix"
    )

    # Test if the Perl variable $desktopConfiguration is spliced correctly
    machine.succeed(
        "grep 'services\\.desktopManager\\.gnome\\.enable = true;' /etc/nixos/configuration.nix"
    )

    machine.succeed("rm -rf /etc/nixos")
    machine.succeed("nixos-generate-config --flake")
    machine.succeed("nix-instantiate --parse /etc/nixos/flake.nix /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix")

    machine.succeed("mv /etc/nixos /etc/nixos-with-flake-arg")
    machine.succeed("printf '[Defaults]\nFlake = 1\n' > /etc/nixos-generate-config.conf")
    machine.succeed("nixos-generate-config")
    machine.succeed("nix-instantiate --parse /etc/nixos/flake.nix /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix")
    machine.succeed("diff -r /etc/nixos /etc/nixos-with-flake-arg")
  '';
}

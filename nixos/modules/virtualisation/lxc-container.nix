{ lib, ... }:

with lib;

{
  imports = [
    ../profiles/docker-container.nix # FIXME, shouldn't include something from profiles/
  ];

  config = {
    system.build.tarball = mkForce (pkgs.callPackage ../../lib/make-system-tarball.nix {
      extraArgs = "--owner=0";

      storeContents = [
        config.system.build.toplevel
      ];

      contents = [
        {
          source = pkgs.writeText "metadata.yaml" ''
            architecture: ${builtins.elemAt (builtins.match "^([a-z0-9_]+).+" (toString pkgs.system)) 0}
            creation_date: 0
            properties:
              description: NixOS ${config.system.nixos.codeName} ${config.system.nixos.label} ${pkgs.system}
              os: nixos
              release: ${config.system.nixos.codeName}
          '';
          target = "/metadata.yaml";
        }
        {
          source = config.system.build.toplevel + "/init";
          target = "/sbin/init";
        }
      ];

      extraCommands = "mkdir -p proc sys dev";
    });

    # Allow the user to login as root without password.
    users.users.root.initialHashedPassword = mkOverride 150 "";

    # Some more help text.
    services.getty.helpLine =
      ''

        Log in as "root" with an empty password.
      '';

    # Containers should be light-weight, so start sshd on demand.
    services.openssh.enable = mkDefault true;
    services.openssh.startWhenNeeded = mkDefault true;

    # Allow ssh connections
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}

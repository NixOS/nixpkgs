{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;

  secretType = lib.types.submodule ({ name, ... }: {
    options = {
      owner = lib.mkOption {
        type = lib.types.str;
        default = "root";
        description = "User that owns the deployed secret file.";
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = "root";
        description = "Group that owns the deployed secret file.";
      };
      mode = lib.mkOption {
        type = lib.types.str;
        default = "0400";
        description = "Octal permission mode for the deployed secret file.";
      };
      path = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Absolute path where the secret will be deployed.
          Defaults to /run/secrets/''${name}.
          Must NOT be inside /nix/store.
        '';
      };
      dummy = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Placeholder content used when the 'dummy' provider is selected.";
      };
    };
  });

in {
  imports = [
    ./providers/sops-nix.nix
    ./providers/agenix.nix
    ./providers/systemd-creds.nix
    ./providers/dummy.nix
  ];

  options.security.artifacts = {
    enable = lib.mkEnableOption "nixos-artifacts backend-agnostic secret management";

    provider = lib.mkOption {
      type = lib.types.enum [ "sops-nix" "agenix" "systemd-creds" "dummy" ];
      description = "The secret management backend to fulfill artifacts requests.";
    };

    secrets = lib.mkOption {
      type = lib.types.attrsOf secretType;
      default = {};
      description = "Declarations of secrets required by the system.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Assertion to prevent store leakage at evaluation time.
    # Evaluates the paths of all secrets and aborts if any are rooted in the Nix store.
    assertions = lib.mapAttrsToList (name: secret: {
      assertion = let
        resolvedPath = if secret.path != null then secret.path else "/run/secrets/${name}";
      in !(lib.hasPrefix builtins.storeDir (builtins.toString resolvedPath));
      message = "nixos-artifacts: secret '${name}' path '${if secret.path != null then builtins.toString secret.path else "/run/secrets/${name}"}' would leak into the Nix store. Use a path under /run/secrets/ instead.";
    }) cfg.secrets;

    # Expose a target for services to depend upon to guarantee secret readiness.
    systemd.targets.nixos-artifacts-secrets = {
      description = "nixos-artifacts secrets provisioned";
      requires = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
    };


  };
}

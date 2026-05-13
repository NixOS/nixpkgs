{ config, lib, pkgs, ... }:

let
  cfg = config.security.artifacts;

  secretType = lib.types.submodule ({ name, ... }: {
    options = {
      owner = lib.mkOption {
        type = lib.types.str;
        default = "root";
        description = lib.mdDoc ''
          User that owns the deployed secret file.
        '';
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = "root";
        description = lib.mdDoc ''
          Group that owns the deployed secret file.
        '';
      };
      mode = lib.mkOption {
        type = lib.types.str;
        default = "0400";
        description = lib.mdDoc ''
          Octal permission mode for the deployed secret file.
        '';
      };
      path = lib.mkOption {
        type = lib.types.str;
        default = "/run/secrets/${name}";
        description = lib.mdDoc ''
          Absolute path where the secret will be deployed at runtime.
          Defaults to `/run/secrets/''${name}`.

          ::: {.warning}
          This path must NOT be inside `/nix/store`.
          :::
        '';
      };
      source = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = lib.mdDoc ''
          Path to the encrypted source file for this secret.

          - For the `sops-nix` provider, this is the `.yaml` or `.json` file encrypted with SOPS.
          - For the `agenix` provider, this is the `.age` file encrypted with age.
          - For `dummy` and `systemd-creds`, this option is unused.

          When using `sops-nix` or `agenix`, this option is **required**.
        '';
      };
      dummy = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = lib.mdDoc ''
          Placeholder content used when the `dummy` provider is selected.
          Only used for testing and CI/CD environments.
        '';
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
    enable = lib.mkEnableOption (lib.mdDoc "backend-agnostic secret management via nixos-artifacts");

    provider = lib.mkOption {
      type = lib.types.enum [ "sops-nix" "agenix" "systemd-creds" "dummy" ];
      description = lib.mdDoc ''
        The secret management backend to fulfill artifacts requests.

        Available providers:
        - `sops-nix` — Uses [sops-nix](https://github.com/Mic92/sops-nix) for decryption.
        - `agenix` — Uses [agenix](https://github.com/ryantm/agenix) for decryption.
        - `systemd-creds` — Uses native systemd encrypted credentials.
        - `dummy` — Writes plaintext values for CI/CD and testing only.
      '';
    };

    secrets = lib.mkOption {
      type = lib.types.attrsOf secretType;
      default = {};
      description = lib.mdDoc ''
        Set of secrets required by the system. Each secret declares
        ownership, permissions, and (optionally) the path to the encrypted
        source file. The active provider translates these declarations into
        the corresponding backend configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # ── Evaluation-time assertions ──────────────────────────────────

    assertions =
      # 1. Prevent store leakage: no secret path may point into /nix/store
      (lib.mapAttrsToList (name: secret: {
        assertion = !(lib.hasPrefix builtins.storeDir (builtins.toString secret.path));
        message = "security.artifacts: secret '${name}' resolves to '${secret.path}', which is inside /nix/store. Use a runtime path like /run/secrets/${name} instead.";
      }) cfg.secrets)

      ++

      # 2. Require `source` for providers that need an encrypted input file
      (lib.optionals (cfg.provider == "sops-nix" || cfg.provider == "agenix")
        (lib.mapAttrsToList (name: secret: {
          assertion = secret.source != null;
          message = "security.artifacts: secret '${name}' requires 'source' when using the '${cfg.provider}' provider. Set security.artifacts.secrets.\"${name}\".source to the path of your encrypted file.";
        }) cfg.secrets));

    # ── Synchronization target ──────────────────────────────────────

    systemd.targets.nixos-artifacts-secrets = {
      description = "All nixos-artifacts secrets have been provisioned";
      requires = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
    };
  };
}

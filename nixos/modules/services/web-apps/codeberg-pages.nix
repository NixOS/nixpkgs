{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    ;
  inherit (lib) types;

  cfg = config.services.codeberg-pages;
in
{
  meta.maintainers = with lib.maintainers; [
    NotAShelf
  ];

  options = {
    services.codeberg-pages = {
      enable = mkEnableOption "Codeberg pages server";
      package = mkPackageOption pkgs "codeberg-pages" { };

      stateDir = mkOption {
        type = types.path;
        default = "/var/lib/codeberg-pages";
        example = "/opt/codeberg-pages";
        description = "Directory in which state will be stored.";
      };

      user = mkOption {
        type = types.str;
        default = "codeberg-pages";
        description = "User account under which Codeberg Pages will run.";
      };

      group = mkOption {
        type = types.str;
        default = "codeberg-pages";
        description = "Group under under which Codeberg Pages will run.";
      };

      settings = mkOption {
        # XXX: Codeberg pages does not appear to have any other types than ints,strings or booleans
        # in its configuration format. Though it *also* expects booleans as "bool" so we should only
        # accept strings and ints (for ports, etc.) If the configuration gets more complex in the
        # future, then additional types must be provided here.
        type =
          with types;
          submodule {
            freeformType = attrsOf (oneOf [
              str
              int
            ]);
          };
        default = { };
        example = {
          ACME_ACCEPT_TERMS = "true";
          ENABLE_HTTP_SERVER = "true";

          HOST = "[::]";
          PORT = "443";

          GITEA_ROOT = "https://git.exampledomain.tld";
        };

        description = ''
          Configuration values to be passed to the codeberg pages server as environment
          variables.

          [pages-server documentation]: https://codeberg.org/Codeberg/pages-server#environment-variables
          See [pages-server documentation] for available options. For sensitive values,
          prefer using {option}`services.codberg-pages.environmentFile`.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secret/pages-server.env";
        description = ''
          An environment file as defined in {manpage}`systemd.exec(5)`.
          Sensitive information, such as {env}`GITEA_API_TOKEN`, may be passed
          to the service without adding them to the world-readable Nix store.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      tmpfiles.settings = {
        "10-codeberge-pages" = {
          ${cfg.stateDir} = {
            d = {
              inherit (cfg) group user;
              mode = "0750";
            };
          };
        };
      };

      services.codeberg-pages = {
        description = "Codeberg Pages Server";
        documentation = [ "https://codeberg.org/Codeberg/pages-server" ];
        wantedBy = [ "multi-user.target" ];
        environment = cfg.settings;
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.stateDir;
          ReadWritePaths = [ cfg.stateDir ];
          ExecStart = "${lib.getExe cfg.package}";
          EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          Restart = "on-failure";
          # Security section directly mimics the one of Forgejo module
          # Capabilities
          CapabilityBoundingSet = "";
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @setuid"
            "setrlimit"
          ];
        };
      };
    };

    # Create user and group if user uses the default user and group.
    users.users = mkIf (cfg.user == "codeberg-pages") {
      codeberg-pages = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "codeberg-pages") {
      codeberg-pages = { };
    };
  };
}

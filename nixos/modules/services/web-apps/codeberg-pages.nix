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
        type = with types; submodule { freeformType = attrsOf anything; }; # TODO: pick available types more carefully?
        default = { };
        example = {
          ACME_ACCEPT_TERMS = true;
          ENABLE_HTTP_SERVER = true;

          GITEA_ROOT = "git.exampledomain.tld";
        };

        description = ''
          Configuration values to be passed to the codeberg pages server
          as environment variables.

          [pages-server documentation]: https://codeberg.org/Codeberg/pages-server#environment-variables

          See [pages-server documentation] for available options.

          For sensitive values, prefer using {option}`services.codberg-pages.environmentFile`.

        '';
      };

      environmentFile = mkOption {
        type = with types; nullOr path;
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
      tmpfiles.rules = [ "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -" ];

      services.codeberg-pages = {
        description = "Codeberg Pages Server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = cfg.settings;
        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = cfg.stateDir;
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

    users.users = mkIf (cfg.user == "codeberg-pages") {
      codeberg-pages = {
        home = cfg.stateDir;
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "codeberg-pages") {
      codeberg-pages = { };
    };
  };
}

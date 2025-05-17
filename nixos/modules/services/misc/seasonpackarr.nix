{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.seasonpackarr;
  settingsFormat = pkgs.formats.yaml { };
  stateDir = "/var/lib/seasonpackarr";
in
{
  meta.maintainers = with lib.maintainers; [ ambroisie ];

  options.services.seasonpackarr = {
    enable = lib.mkEnableOption "seasonpackarr service";

    package = lib.mkPackageOption pkgs "seasonpackarr" { };

    settings = lib.mkOption {
      default = { };
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          port = lib.mkOption {
            type = lib.types.port;
            default = 42069;
            example = 8000;
            description = "Port the seasonpackarr daemon listens on.";
          };
        };
      };

      example = {
        apiToken = {
          _secret = "/run/credentials/seasonpackarr.service/apiToken";
        };

        clients = {
          default = {
            host = "127.0.0.1";
            port = 8080;
            username = "admin";
            password = {
              _secret = "/run/credentials/seasonpackarr.service/qbittorentPassword";
            };
            preImportPath = "/data/torrents/tv-hd";
          };
        };
      };
      description = ''
        Configuration options for seasonpackarr.

        The configuration is processed using [utils.genJqSecretsReplacementSnippet](https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/utils.nix#L232-L331) to handle secret substitution.

        To avoid permission issues, secrets should be provided via systemd's credential mechanism:

        ```nix
        systemd.services.seasonpackarr.serviceConfig.LoadCredential = [
          "apiToken:''${config.sops.secrets.apiToken.path}"
          "qbittorentPassword:''${config.sops.secrets.qbittorentPassword.path}"
        ];
        ```
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "seasonpackarr";
      description = "User account under which seasonpackarr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "seasonpackarr";
      description = "Group under which seasonpackarr runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.seasonpackarr = {
      description = "seasonpackarr";
      wantedBy = [ "multi-user.target" ];

      # YAML is a JSON super-set
      preStart = utils.genJqSecretsReplacementSnippet cfg.settings "${stateDir}/config.yaml";

      serviceConfig = {
        Type = "simple";
        # `--config` expects a directory which contains `config.yaml`...
        ExecStart = "${lib.getExe cfg.package} start --config ${stateDir}";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";

        StateDirectory = "seasonpackarr";

        # Only allow binding to the specified port.
        SocketBindDeny = "any";
        SocketBindAllow = cfg.settings.port;

        # Security options:
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = false;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@clock"
          "~@aio"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@setuid"
          "~@swap"
        ];
        SystemCallErrorNumber = "EPERM";
      };
    };

    users.users = lib.mkIf (cfg.user == "seasonpackarr") {
      seasonpackarr = {
        isSystemUser = true;
        description = "seasonpackarr user";
        home = stateDir;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "seasonpackarr") {
      ${cfg.group} = { };
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ntfy-sh;

  settingsFormat = pkgs.formats.yaml { };
in

{
  options.services.ntfy-sh = {
    enable = mkEnableOption (mdDoc "[ntfy-sh](https://ntfy.sh), a push notification service");

    package = mkOption {
      type = types.package;
      default = pkgs.ntfy-sh;
      defaultText = literalExpression "pkgs.ntfy-sh";
      description = mdDoc "The ntfy.sh package to use.";
    };

    user = mkOption {
      default = "ntfy-sh";
      type = types.str;
      description = lib.mdDoc "User the ntfy-sh server runs under.";
    };

    group = mkOption {
      default = "ntfy-sh";
      type = types.str;
      description = lib.mdDoc "Primary group of ntfy-sh user.";
    };

    settings = mkOption {
      type = types.submodule { freeformType = settingsFormat.type; };

      default = { };

      example = literalExpression ''
        {
          listen-http = ":8080";
        }
      '';

      description = mdDoc ''
        Configuration for ntfy.sh, supported values are [here](https://ntfy.sh/docs/config/#config-options).
      '';
    };
  };

  config =
    let
      configuration = settingsFormat.generate "server.yml" cfg.settings;
    in
    mkIf cfg.enable {
      # to configure access control via the cli
      environment = {
        etc."ntfy/server.yml".source = configuration;
        systemPackages = [ cfg.package ];
      };

      services.ntfy-sh.settings = {
        auth-file = mkDefault "/var/lib/ntfy-sh/user.db";
      };

      systemd.services.ntfy-sh = {
        description = "Push notifications server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/ntfy serve -c ${configuration}";
          User = cfg.user;
          StateDirectory = "ntfy-sh";

          AmbientCapabilities = "CAP_NET_BIND_SERVICE";
          PrivateTmp = true;
          NoNewPrivileges = true;
          CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
          ProtectSystem = "full";
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          PrivateDevices = true;
          RestrictSUIDSGID = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          MemoryDenyWriteExecute = true;
        };
      };

      users.groups = optionalAttrs (cfg.group == "ntfy-sh") {
        ntfy-sh = { };
      };

      users.users = optionalAttrs (cfg.user == "ntfy-sh") {
        ntfy-sh = {
          isSystemUser = true;
          group = cfg.group;
        };
      };
    };
}

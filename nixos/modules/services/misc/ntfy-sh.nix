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
        listen-http = mkDefault "127.0.0.1:2586";
        attachment-cache-dir = mkDefault "/var/lib/ntfy-sh/attachments";
        cache-file = mkDefault "/var/lib/ntfy-sh/cache-file.db";
      };

      systemd.services.ntfy-sh = {
        description = "Push notifications server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStartPre = [
            "${pkgs.coreutils}/bin/touch ${cfg.settings.auth-file}"
            "${pkgs.coreutils}/bin/mkdir -p ${cfg.settings.attachment-cache-dir}"
            "${pkgs.coreutils}/bin/touch ${cfg.settings.cache-file}"
          ];
          ExecStart = "${cfg.package}/bin/ntfy serve -c ${configuration}";
          StateDirectory = "ntfy-sh";

          DynamicUser = true;
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
          # Upstream Requirements
          LimitNOFILE = 20500;
        };
      };
    };
}

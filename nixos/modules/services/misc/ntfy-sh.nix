{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ntfy-sh;

  settingsFormat = pkgs.formats.yaml { };
in

{
  options.services.ntfy-sh = {
    enable = lib.mkEnableOption "[ntfy-sh](https://ntfy.sh), a push notification service";

    package = lib.mkPackageOption pkgs "ntfy-sh" { };

    user = lib.mkOption {
      default = "ntfy-sh";
      type = lib.types.str;
      description = "User the ntfy-sh server runs under.";
    };

    group = lib.mkOption {
      default = "ntfy-sh";
      type = lib.types.str;
      description = "Primary group of ntfy-sh user.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          base-url = lib.mkOption {
            type = lib.types.str;
            example = "https://ntfy.example";
            description = ''
              Public facing base URL of the service

              This setting is required for any of the following features:
              - attachments (to return a download URL)
              - e-mail sending (for the topic URL in the email footer)
              - iOS push notifications for self-hosted servers
                (to calculate the Firebase poll_request topic)
              - Matrix Push Gateway (to validate that the pushkey is correct)
            '';
          };
        };
      };

      default = { };

      example = lib.literalExpression ''
        {
          listen-http = ":8080";
        }
      '';

      description = ''
        Configuration for ntfy.sh, supported values are [here](https://ntfy.sh/docs/config/#config-options).
      '';
    };
  };

  config =
    let
      configuration = settingsFormat.generate "server.yml" cfg.settings;
    in
    lib.mkIf cfg.enable {
      # to configure access control via the cli
      environment = {
        etc."ntfy/server.yml".source = configuration;
        systemPackages = [ cfg.package ];
      };

      services.ntfy-sh.settings = {
        auth-file = lib.mkDefault "/var/lib/ntfy-sh/user.db";
        listen-http = lib.mkDefault "127.0.0.1:2586";
        attachment-cache-dir = lib.mkDefault "/var/lib/ntfy-sh/attachments";
        cache-file = lib.mkDefault "/var/lib/ntfy-sh/cache-file.db";
      };

      systemd.services.ntfy-sh = {
        description = "Push notifications server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/ntfy serve -c ${configuration}";
          User = cfg.user;
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
          # Upstream Recommandation
          LimitNOFILE = 20500;
        };
      };

      users.groups = lib.optionalAttrs (cfg.group == "ntfy-sh") {
        ntfy-sh = { };
      };

      users.users = lib.optionalAttrs (cfg.user == "ntfy-sh") {
        ntfy-sh = {
          isSystemUser = true;
          group = cfg.group;
        };
      };
    };
}

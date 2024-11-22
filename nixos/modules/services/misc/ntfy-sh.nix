{ config, lib, pkgs, ... }:

let
  cfg = config.services.ntfy-sh;
  settingsFormat = pkgs.formats.yaml { };
in

{
  options.services.ntfy-sh = {
    enable = lib.mkEnableOption "ntfy-sh, a push notification service";

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

    smtpSenderPass = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The password for the SMTP sender.
        For improved security, consider using 'smtpSenderPassFile' instead
        which keeps credentials out of the Nix store.
      '';
    };

    smtpSenderPassFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the password for the SMTP sender.
        Uses systemd's LoadCredential feature for secure runtime secret handling,
        preventing the secret from being written to the Nix store.
      '';
    };

    webPushPrivateKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        The private key for web push notifications.
        For improved security, consider using 'webPushPrivateKeyFile' instead
        which keeps credentials out of the Nix store.
      '';
    };

    webPushPrivateKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the private key for web push notifications.
        Uses systemd's LoadCredential feature for secure runtime secret handling,
        preventing the secret from being written to the Nix store.
      '';
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
        Configuration for ntfy.sh, supported values are documented at
        <https://ntfy.sh/docs/config/#config-options>
      '';
    };
  };

  config =
    let
      configuration = settingsFormat.generate "server.yml" cfg.settings;
    in
    lib.mkIf cfg.enable {
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

        environment = lib.mkIf (cfg.smtpSenderPassFile != null || cfg.webPushPrivateKeyFile != null) {
          CREDENTIALS_DIRECTORY = "%d/credentials";
          SMTP_SENDER_PASS = lib.mkIf (cfg.smtpSenderPassFile != null)
            "$(cat $CREDENTIALS_DIRECTORY/smtp_pass)";
          WEB_PUSH_PRIVATE_KEY = lib.mkIf (cfg.webPushPrivateKeyFile != null)
            "$(cat $CREDENTIALS_DIRECTORY/webpush_key)";
        };

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/ntfy serve -c ${configuration}";
          User = cfg.user;
          StateDirectory = "ntfy-sh";

          LoadCredential =
            (lib.optional (cfg.smtpSenderPassFile != null) "smtp_pass:${cfg.smtpSenderPassFile}" ++
              lib.optional (cfg.webPushPrivateKeyFile != null) "webpush_key:${cfg.webPushPrivateKeyFile}");

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

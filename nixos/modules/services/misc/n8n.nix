{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.n8n;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "n8n" "settings" ] "Use services.n8n.environment instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "n8n"
      "webhookUrl"
    ] "Use services.n8n.environment.WEBHOOK_URL instead.")
  ];

  options.services.n8n = {
    enable = lib.mkEnableOption "n8n server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for the n8n web interface.";
    };

    environment = lib.mkOption {
      description = ''
        Environment variables to pass to the n8n service.
        See <https://docs.n8n.io/hosting/configuration/environment-variables/> for available options.
      '';
      type = lib.types.submodule {
        freeformType = with lib.types; attrsOf str;
        options = {
          GENERIC_TIMEZONE = lib.mkOption {
            type = with lib.types; nullOr str;
            default = config.time.timeZone;
            defaultText = lib.literalExpression "config.time.timeZone";
            description = ''
              The n8n instance timezone. Important for schedule nodes (such as Cron).
            '';
          };
          N8N_PORT = lib.mkOption {
            type = with lib.types; coercedTo port toString str;
            default = 5678;
            description = "The HTTP port n8n runs on.";
          };
          N8N_USER_FOLDER = lib.mkOption {
            type = lib.types.path;
            # This folder must be writeable as the application is storing
            # its data in it, so the StateDirectory is a good choice
            default = "/var/lib/n8n";
            description = ''
              Provide the path where n8n will create the .n8n folder.
              This directory stores user-specific data, such as database file and encryption key.
            '';
            readOnly = true;
          };
          N8N_DIAGNOSTICS_ENABLED = lib.mkOption {
            type = with lib.types; coercedTo bool toString str;
            default = false;
            description = ''
              Whether to share selected, anonymous telemetry with n8n.
              Note that if you set this to false, you can't enable Ask AI in the Code node.
            '';
          };
          N8N_VERSION_NOTIFICATIONS_ENABLED = lib.mkOption {
            type = with lib.types; coercedTo bool toString str;
            default = false;
            description = ''
              When enabled, n8n sends notifications of new versions and security updates.
            '';
          };
        };
      };
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.n8n = {
      description = "n8n service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment // {
        HOME = config.services.n8n.environment.N8N_USER_FOLDER;
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.n8n}/bin/n8n";
        Restart = "on-failure";
        StateDirectory = "n8n";

        # Basic Hardening
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        DynamicUser = "true";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "no"; # v8 JIT requires memory segments to be Writable-Executable.
        LockPersonality = "yes";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ (lib.toInt cfg.environment.N8N_PORT) ];
    };
  };
}

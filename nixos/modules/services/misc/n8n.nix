{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.n8n;
  format = pkgs.formats.json { };
  configFile = format.generate "n8n.json" cfg.settings;
in
{
  options.services.n8n = {
    enable = lib.mkEnableOption "n8n server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for the n8n web interface.";
    };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for n8n, see <https://docs.n8n.io/hosting/environment-variables/configuration-methods/>
        for supported values.

        ::: {.warning}
        Since n8n 1.70.0, the configuration file is deprecated.
        Use `services.n8n.environment` instead.
        :::
      '';
    };

    webhookUrl = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        WEBHOOK_URL for n8n, in case we're running behind a reverse proxy.
        This cannot be set through configuration and must reside in an environment variable.

        ::: {.warning}
        This option is deprecated. Use `services.n8n.environment.WEBHOOK_URL` instead.
        :::
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        WEBHOOK_URL = "https://n8n.example.com/";
        N8N_PORT = "5678";
      };
      description = ''
        Environment variables to pass to the n8n service.
        See <https://docs.n8n.io/hosting/environment-variables/> for available options.
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    services.n8n.environment = rec {
      # This folder must be writeable as the application is storing
      # its data in it, so the StateDirectory is a good choice
      N8N_USER_FOLDER = lib.mkDefault "/var/lib/n8n";
      HOME = N8N_USER_FOLDER;

      # We use this to open the firewall, so we need to know about the default at eval time
      N8N_PORT = lib.mkDefault "5678";

      # Don't phone home
      N8N_DIAGNOSTICS_ENABLED = lib.mkDefault "false";
      N8N_VERSION_NOTIFICATIONS_ENABLED = lib.mkDefault "false";
    }
    // lib.optionalAttrs (cfg.webhookUrl != "") {
      WEBHOOK_URL = cfg.webhookUrl;
    }
    // lib.optionalAttrs (cfg.settings != { }) {
      N8N_CONFIG_FILES = "${configFile}";
    };

    systemd.services.n8n = {
      description = "N8N service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment;
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

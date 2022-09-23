{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.n8n;
  format = pkgs.formats.json {};
  configFile = format.generate "n8n.json" cfg.settings;
in
{
  options.services.n8n = {

    enable = mkEnableOption (lib.mdDoc "n8n server");

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Open ports in the firewall for the n8n web interface.";
    };

    settings = mkOption {
      type = format.type;
      default = {};
      description = lib.mdDoc ''
        Configuration for n8n, see <https://docs.n8n.io/reference/configuration.html>
        for supported values.
      '';
    };

  };

  config = mkIf cfg.enable {
    services.n8n.settings = {
      # We use this to open the firewall, so we need to know about the default at eval time
      port = lib.mkDefault 5678;
    };

    systemd.services.n8n = {
      description = "N8N service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        # This folder must be writeable as the application is storing
        # its data in it, so the StateDirectory is a good choice
        N8N_USER_FOLDER = "/var/lib/n8n";
        HOME = "/var/lib/n8n";
        N8N_CONFIG_FILES = "${configFile}";
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

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };
  };
}

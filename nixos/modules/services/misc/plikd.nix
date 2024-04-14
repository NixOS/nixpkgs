{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.plikd;

  format = pkgs.formats.toml {};
  plikdCfg = format.generate "plikd.cfg" cfg.settings;
in
{
  options = {
    services.plikd = {
      enable = mkEnableOption "plikd, a temporary file upload system";

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the plikd.";
      };

      settings = mkOption {
        type = format.type;
        default = {};
        description = ''
          Configuration for plikd, see <https://github.com/root-gg/plik/blob/master/server/plikd.cfg>
          for supported values.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.plikd.settings = mapAttrs (name: mkDefault) {
      ListenPort = 8080;
      ListenAddress = "localhost";
      DataBackend = "file";
      DataBackendConfig = {
         Directory = "/var/lib/plikd";
      };
      MetadataBackendConfig = {
        Driver = "sqlite3";
        ConnectionString = "/var/lib/plikd/plik.db";
      };
    };

    systemd.services.plikd = {
      description = "Plikd file sharing server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.plikd}/bin/plikd --config ${plikdCfg}";
        Restart = "on-failure";
        StateDirectory = "plikd";
        LogsDirectory = "plikd";
        DynamicUser = true;

        # Basic hardening
        NoNewPrivileges = "yes";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        DevicePolicy = "closed";
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ProtectControlGroups = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = "yes";
        RestrictRealtime = "yes";
        RestrictSUIDSGID = "yes";
        MemoryDenyWriteExecute = "yes";
        LockPersonality = "yes";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.ListenPort ];
    };
  };
}

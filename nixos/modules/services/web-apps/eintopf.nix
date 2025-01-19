{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.eintopf;

in
{
  options.services.eintopf = {

    enable = mkEnableOption "Eintopf community event calendar web app";

    settings = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Settings to configure web service. See
        <https://codeberg.org/Klasse-Methode/eintopf/src/branch/main/DEPLOYMENT.md>
        for available options.
      '';
      example = literalExpression ''
        {
          EINTOPF_ADDR = ":1234";
          EINTOPF_ADMIN_EMAIL = "admin@example.org";
          EINTOPF_TIMEZONE = "Europe/Berlin";
        }
      '';
    };

    secrets = lib.mkOption {
      type = with types; listOf path;
      description = ''
        A list of files containing the various secrets. Should be in the
        format expected by systemd's `EnvironmentFile` directory.
      '';
      default = [ ];
    };

  };

  config = mkIf cfg.enable {

    systemd.services.eintopf = {
      description = "Community event calendar web app";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment = cfg.settings;
      serviceConfig = {
        ExecStart = "${pkgs.eintopf}/bin/eintopf";
        WorkingDirectory = "/var/lib/eintopf";
        StateDirectory = "eintopf";
        EnvironmentFile = [ cfg.secrets ];

        # hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}

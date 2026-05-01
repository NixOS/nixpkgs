{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.lauti;
  useLegacyDefault = lib.versionOlder config.system.stateVersion "26.05";
  default = if useLegacyDefault then "eintopf" else "lauti";

in
{

  imports = [
    # since 0.12.0 (2025-05-26) release, upstream re-branded project to 'stalwart' due to inclusion of collaboration features (CalDAV, CardDAV, and WebDAV)
    #  https://github.com/stalwartlabs/stalwart/releases/tag/v0.12.0
    (lib.mkRenamedOptionModule [ "services" "eintopf" ] [ "services" "lauti" ])
  ];

  options.services.lauti = {

    enable = mkEnableOption "Lauti community event calendar web app";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = if useLegacyDefault then "/var/lib/eintopf" else "/var/lib/lauti";
      description = ''
        Data directory for Lauti
      '';
    };

    settings = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = ''
        Settings to configure web service. See
        <https://codeberg.org/Klasse-Methode/lauti/src/branch/main/DEPLOYMENT.md>
        for available options.
      '';
      example = literalExpression ''
        {
          LAUTI_ADDR = ":1234";
          LAUTI_ADMIN_EMAIL = "admin@example.org";
          LAUTI_TIMEZONE = "Europe/Berlin";
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

    systemd.services.lauti = {
      description = "Community event calendar web app";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      environment = cfg.settings;
      serviceConfig = {
        ExecStart = lib.getExe pkgs.lauti;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = default;
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

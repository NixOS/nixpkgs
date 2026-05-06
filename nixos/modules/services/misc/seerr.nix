{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.seerr;
  # 26.05 introduced a breaking change which is guarded behind stateVersion to avoid
  # breaking users.
  useNewConfigLocation = cfg.stateVersion >= 1;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "jellyseerr" ] [ "services" "seerr" ])
  ];

  meta.maintainers = with lib.maintainers; [
    camillemndn
    fallenbagel
  ];

  options.services.seerr = {
    enable = lib.mkEnableOption "Seerr, a requests manager for Jellyfin";
    package = lib.mkPackageOption pkgs "seerr" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open port in the firewall for the Seerr web interface.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "The port which the Seerr web UI should listen to.";
    };

    configDir = lib.mkOption {
      type = lib.types.path;
      default = if useNewConfigLocation then "/var/lib/seerr/" else "/var/lib/jellyseerr/config";
      defaultText = lib.literalMD "{file}`/var/lib/seerr` (or {file}`/var/lib/jellyseerr/config` if {option}`services.seerr.stateVersion` < 1)";
      description = "Config data directory";
    };

    stateVersion = lib.mkStateVersionOption config "Seerr" {
      "26.05" = ''
        Move {file}`/var/lib/private/jellyseerr/config` to
        {file}`/var/lib/private/seerr`, if you have not set
        {option}`services.seerr.configDir`. (If you have set
        {option}`services.seerr.configDir`, you should also have forced
        {option}`systemd.services.seerr.serviceConfig.StateDirectory`, and in
        that case `stateVersion` does not affect your configuration.)
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.seerr = {
      description = "Seerr, a requests manager for Jellyfin";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        PORT = toString cfg.port;
        CONFIG_DIRECTORY = cfg.configDir;
      };
      serviceConfig = {
        Type = "exec";
        # Note: this should be a parent of configDir.
        StateDirectory = if useNewConfigLocation then "seerr" else "jellyseerr";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    system.moduleStateVersions."services.seerr.stateVersion" = cfg.stateVersion;
  };
}

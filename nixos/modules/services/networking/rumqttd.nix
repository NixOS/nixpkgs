{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.rumqttd;
  settingsFormat = pkgs.formats.toml { };
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    getExe
    types
    ;
in
{
  options.services.rumqttd = {
    enable = mkEnableOption "rumqttd";

    package = mkPackageOption pkgs "rumqttd" { };

    settings = {
      type = settingsFormat.type;
      default = { };
    };

    #servers-v4
    #servers-v5
    # openFirewall = mkOption {
    #   type = types.bool;
    #   default = false;
    #   description = ''
    #     Whether to open the firewall for the rumqttd MQTT broker
    #   '';
    # };
  };

  config =
    let
      configFile = settingsFormat.generate "rumqttd.toml" cfg.settings;
    in
    mkIf cfg.enable {
      systemd.services.rumqttd = {
        description = "MQTT broker";
        documentation = "https://rumqtt.bytebeam.io/docs/rumqttd/Introduction";

        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          User = "rumqtt";
          Group = "rumqtt";
          PrivateTmp = true;
          ProtectHome = true;
          ProtectSystem = "strict";
          ProtectKernelTunables = true;
          ProtectHostname = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          NoNewPrivileges = true;
          PrivateDevices = true;
          DeviceAllow = "/dev/syslog";
          RestrictSUIDSGID = true;
          ProtectKernelModules = true;
          MemoryDenyWriteExecute = true;
          RestrictNamespaces = true;
          RestrictRealtime = true;
          LockPersonality = true;
          TimeoutStopSec = "7s";
          KillMode = "mixed";
          KillSignal = "SIGTERM";
          Restart = "on-failure";
          RestartPreventExitStatus = "2";
          ExecStart = "${getExe cfg.package} --config ${configFile}";
        };
      };

      users.users.rumqtt = {
        isSystemUser = true;
        group = "rumqtt";
        description = "rumqtt MQTT ecosystem in rust";
      };
      users.groups.rumqtt = { };
    };

  meta.maintainers = with lib.maintainers; [ griffi-gh ];
}

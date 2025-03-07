{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.flood;
in
{
  meta.maintainers = with lib.maintainers; [ thiagokokada ];

  options.services.flood = {
    enable = lib.mkEnableOption "flood";
    package = lib.mkPackageOption pkgs "flood" { };
    openFirewall = lib.mkEnableOption "" // {
      description = "Whether to open the firewall for the port in {option}`services.flood.port`.";
    };
    port = lib.mkOption {
      type = lib.types.int;
      description = "Port to bind webserver.";
      default = 3000;
      example = 3001;
    };
    host = lib.mkOption {
      type = lib.types.str;
      description = "Host to bind webserver.";
      default = "localhost";
      example = "::";
    };
    extraArgs = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Extra arguments passed to `flood`.";
      default = [ ];
      example = [ "--baseuri=/" ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.flood = {
      description = "A modern web UI for various torrent clients.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        Documentation = "https://github.com/jesec/flood/wiki";
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "3s";
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "--host"
            cfg.host
            "--port"
            (toString cfg.port)
            "--rundir=/var/lib/flood"
          ]
          ++ cfg.extraArgs
        );

        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        StateDirectory = "flood";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
          "~@privileged"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];
  };
}

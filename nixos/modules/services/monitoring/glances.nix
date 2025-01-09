{
  pkgs,
  config,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.glances;

  inherit (lib)
    getExe
    maintainers
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    ;

  inherit (lib.types)
    bool
    listOf
    port
    str
    ;

  inherit (utils)
    escapeSystemdExecArgs
    ;

in
{
  options.services.glances = {
    enable = mkEnableOption "Glances";

    package = mkPackageOption pkgs "glances" { };

    port = mkOption {
      description = "Port the server will isten on.";
      type = port;
      default = 61208;
    };

    openFirewall = mkOption {
      description = "Open port in the firewall for glances.";
      type = bool;
      default = false;
    };

    extraArgs = mkOption {
      type = listOf str;
      default = [ "--webserver" ];
      example = [
        "--webserver"
        "--disable-webui"
      ];
      description = ''
        Extra command-line arguments to pass to glances.

        See https://glances.readthedocs.io/en/latest/cmds.html for all available options.
      '';
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services."glances" = {
      description = "Glances";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        ExecStart = "${getExe cfg.package} --port ${toString cfg.port} ${escapeSystemdExecArgs cfg.extraArgs}";
        Restart = "on-failure";

        NoNewPrivileges = true;
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        ReadWritePaths = [ "/var/log" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        SystemCallFilter = [ "@system-service" ];
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with maintainers; [ claha ];
}

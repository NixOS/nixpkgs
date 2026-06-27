{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.comlsldd;

  generateEvenOddPortsFromRange =
    from: range:
    if range <= 0 then [ ] else [ from ] ++ (generateEvenOddPortsFromRange (from + 2) (range - 2));

  portsToOpen =
    let
      portRange = if (cfg ? liblslConfig.ports.PortRange) then cfg.liblslConfig.ports.PortRange else 32;
      multicastPort =
        if (cfg ? liblslConfig.ports.MulticastPort) then cfg.liblslConfig.ports.MulticastPort else 16571;
      basePort = if (cfg ? liblslConfig.ports.BasePort) then cfg.liblslConfig.ports.BasePort else 16572;
    in
    (generateEvenOddPortsFromRange multicastPort portRange)
    ++ (generateEvenOddPortsFromRange basePort portRange);
in
{
  options.services.comlsldd = {
    enable = mkEnableOption "COMmon LSL Driver Daemon service";

    package = mkPackageOption pkgs "comlsldd" { };

    openFirewall = mkEnableOption "firewall rules to expose LSL";

    liblslConfig = mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        liblsl configuration options

        See https://labstreaminglayer.readthedocs.io/info/lslapicfg.html for more information
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.comlsldd = {
      inherit (cfg.package.meta) description;
      wantedBy = [ "multi-user.target" ];

      environment = {
        RUST_LOG = mkDefault "info";
        LSLAPICFG = pkgs.writers.writeTOML "lsl_api.cfg" cfg.liblslConfig;
      };

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Type = "notify";

        # Hardening
        AmbientCapabilities = [ "CAP_SYS_NICE" ];
        CapabilityBoundingSet = [ "CAP_SYS_NICE" ];
        DynamicUser = true;
        KeyringMode = "private";
        ProtectHome = true;
        ProcSubset = "pid";
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectProc = "invisible";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectClock = true;
        PrivateDevices = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          # D-Bus
          "AF_UNIX"
          # LSL
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = portsToOpen;
      allowedUDPPorts = portsToOpen;
    };
  };

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}

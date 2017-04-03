{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.aiccu;
  showBool = b: if b then "true" else "false";
  notNull = a: ! isNull a;
  configFile = pkgs.writeText "aiccu.conf" ''
    ${if notNull cfg.username then "username " + cfg.username else ""}
    ${if notNull cfg.password then "password " + cfg.password else ""}
    protocol ${cfg.protocol}
    server ${cfg.server}
    ipv6_interface ${cfg.interfaceName}
    verbose ${showBool cfg.verbose}
    daemonize true
    automatic ${showBool cfg.automatic}
    requiretls ${showBool cfg.requireTLS}
    pidfile ${cfg.pidFile}
    defaultroute ${showBool cfg.defaultRoute}
    ${if notNull cfg.setupScript then cfg.setupScript else ""}
    makebeats ${showBool cfg.makeHeartBeats}
    noconfigure ${showBool cfg.noConfigure}
    behindnat ${showBool cfg.behindNAT}
    ${if cfg.localIPv4Override then "local_ipv4_override" else ""}
  '';

in {

  options = {

    services.aiccu = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable aiccu IPv6 over IPv4 SiXXs tunnel";
      };

      username = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "FAB5-SIXXS";
        description = "Login credential";
      };

      password = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "TmAkRbBEr0";
        description = "Login credential";
      };

      protocol = mkOption {
        type = types.str;
        default = "tic";
        example = "tic|tsp|l2tp";
        description = "Protocol to use for setting up the tunnel";
      };

      server = mkOption {
        type = types.str;
        default = "tic.sixxs.net";
        example = "enabled.ipv6server.net";
        description = "Server to use for setting up the tunnel";
      };

      interfaceName = mkOption {
        type = types.str;
        default = "aiccu";
        example = "sixxs";
        description = ''
          The name of the interface that will be used as a tunnel interface.
          On *BSD the ipv6_interface should be set to gifX (eg gif0) for proto-41 tunnels
          or tunX (eg tun0) for AYIYA tunnels.
        '';
      };

      tunnelID = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "T12345";
        description = "The tunnel id to use, only required when there are multiple tunnels in the list";
      };

      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Be verbose?";
      };

      automatic = mkOption {
        type = types.bool;
        default = true;
        description = "Automatic Login and Tunnel activation";
      };

      requireTLS = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When set to true, if TLS is not supported on the server
          the TIC transaction will fail.
          When set to false, it will try a starttls, when that is
          not supported it will continue.
          In any case if AICCU is build with TLS support it will
          try to do a 'starttls' to the TIC server to see if that
          is supported.
        '';
      };

      pidFile = mkOption {
        type = types.path;
        default = "/run/aiccu.pid";
        example = "/var/lib/aiccu/aiccu.pid";
        description = "Location of PID File";
      };

      defaultRoute = mkOption {
        type = types.bool;
        default = true;
        description = "Add a default route";
      };

      setupScript = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/var/lib/aiccu/fix-subnets.sh";
        description = "Script to run after setting up the interfaces";
      };

      makeHeartBeats = mkOption {
        type = types.bool;
        default = true;
        description = ''
          In general you don't want to turn this off
          Of course only applies to AYIYA and heartbeat tunnels not to static ones
        '';
      };

      noConfigure = mkOption {
        type = types.bool;
        default = false;
        description = "Don't configure anything";
      };

      behindNAT = mkOption {
        type = types.bool;
        default = false;
        description = "Notify the user that a NAT-kind network is detected";
      };

      localIPv4Override = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Overrides the IPv4 parameter received from TIC
          This allows one to configure a NAT into "DMZ" mode and then
          forwarding the proto-41 packets to an internal host.

          This is only needed for static proto-41 tunnels!
          AYIYA and heartbeat tunnels don't require this.
        '';
      };

    };
  };

  config = mkIf cfg.enable {

    systemd.services.aiccu = {
      description = "Automatic IPv6 Connectivity Client Utility";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.aiccu}/bin/aiccu start ${configFile}";
        ExecStop = "${pkgs.aiccu}/bin/aiccu stop";
        Type = "forking";
        PIDFile = cfg.pidFile;
        Restart = "no"; # aiccu startup errors are serious, do not pound the tic server or be banned.
      };
    };

  };
}

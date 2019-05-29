{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.pixiecore;

in

{

  options = {

    services.pixiecore = {

      enable = mkEnableOption "Pixiecore";

      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Log more things that aren't directly related to booting a recognized client";
      };

      logTimestamps = mkOption {
        type = types.bool;
        default = true;
        description = "Add a timestamp to each log line";
      };

      dhcpNoBind = mkOption {
        type = types.bool;
        default = false;
        description = "Handle DHCP traffic without binding to the DHCP server port";
      };

      bootMsg = mkOption {
        type = types.nullOr types.string;
        default = "";
        description = "Message to print on machines before booting";
      };

      kernel = mkOption {
        type = types.string;
        default = "";
        description = "Kernel path";
      };

      initrd = mkOption {
        type = types.string;
        default = "";
        description = "Initrd path";
      };

      cmdLine = mkOption {
        type = types.nullOr types.string;
        default = "";
        description = "Kernel commandline arguments";
      };

      listen = mkOption {
        type = types.string;
        default = "0.0.0.0";
        description = "IPv4 address to listen on";
      };

      port = mkOption {
        type = types.int;
        default = 80;
        description = "Port to listen on for HTTP";
      };

      statusPort = mkOption {
        type = types.int;
        default = 80;
        description = "HTTP port for status information (can be the same as --port)";
      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.pixiecore = {
      description = "Netboot server";
      after = [ "network.target"];
      wants = [ "network.target"];
      wantedBy = [ "multi-user.target"];
      serviceConfig = {
        Type="simple";
        PIDFile="/run/pixiecore.pid";
        DynamicUser="yes";
        AmbientCapabilities = "cap_net_bind_service";
        ExecStart  = "${pkgs.pixiecore}/bin/pixiecore boot ${cfg.kernel} ${cfg.initrd} ${optionalString (cfg.cmdLine != "") "--cmdline=\\\'${cfg.cmdLine}\\\'"} ${optionalString cfg.debug "--debug"} ${optionalString cfg.logTimestamps "--log-timestamps"} ${optionalString cfg.dhcpNoBind "--dhcp-no-bind"} ${optionalString (cfg.listen != "") "--listen-addr ${cfg.listen}"} ${optionalString (cfg.port != 0) "--port ${toString cfg.port}"} ${optionalString (cfg.statusPort!= 0) "--status-port ${toString cfg.statusPort}"}";

      };
    };

  };

}

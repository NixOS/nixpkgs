{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pixiecore;
in
{
  meta.maintainers = with maintainers; [ bbigras danderson ];

  options = {
    services.pixiecore = {
      enable = mkEnableOption (lib.mdDoc "Pixiecore");

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports (67, 69 UDP and 4011, 'port', 'statusPort' TCP) in the firewall for Pixiecore.
        '';
      };

      mode = mkOption {
        description = lib.mdDoc "Which mode to use";
        default = "boot";
        type = types.enum [ "api" "boot" ];
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Log more things that aren't directly related to booting a recognized client";
      };

      dhcpNoBind = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Handle DHCP traffic without binding to the DHCP server port";
      };

      kernel = mkOption {
        type = types.str or types.path;
        default = "";
        description = lib.mdDoc "Kernel path. Ignored unless mode is set to 'boot'";
      };

      initrd = mkOption {
        type = types.str or types.path;
        default = "";
        description = lib.mdDoc "Initrd path. Ignored unless mode is set to 'boot'";
      };

      cmdLine = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc "Kernel commandline arguments. Ignored unless mode is set to 'boot'";
      };

      listen = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc "IPv4 address to listen on";
      };

      port = mkOption {
        type = types.port;
        default = 80;
        description = lib.mdDoc "Port to listen on for HTTP";
      };

      statusPort = mkOption {
        type = types.port;
        default = 80;
        description = lib.mdDoc "HTTP port for status information (can be the same as --port)";
      };

      apiServer = mkOption {
        type = types.str;
        example = "localhost:8080";
        description = lib.mdDoc "host:port to connect to the API. Ignored unless mode is set to 'api'";
      };

      extraArguments = mkOption {
        type = types.listOf types.str;
        default = [];
        description = lib.mdDoc "Additional command line arguments to pass to Pixiecore";
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.pixiecore = {};
    users.users.pixiecore = {
      description = "Pixiecore daemon user";
      group = "pixiecore";
      isSystemUser = true;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 4011 cfg.port cfg.statusPort ];
      allowedUDPPorts = [ 67 69 ];
    };

    systemd.services.pixiecore = {
      description = "Pixiecore server";
      after = [ "network.target"];
      wants = [ "network.target"];
      wantedBy = [ "multi-user.target"];
      serviceConfig = {
        User = "pixiecore";
        Restart = "always";
        AmbientCapabilities = [ "cap_net_bind_service" ] ++ optional cfg.dhcpNoBind "cap_net_raw";
        ExecStart =
          let
            argString =
              if cfg.mode == "boot"
              then [ "boot" cfg.kernel ]
                   ++ optional (cfg.initrd != "") cfg.initrd
                   ++ optionals (cfg.cmdLine != "") [ "--cmdline" cfg.cmdLine ]
              else [ "api" cfg.apiServer ];
          in
            ''
              ${pkgs.pixiecore}/bin/pixiecore \
                ${lib.escapeShellArgs argString} \
                ${optionalString cfg.debug "--debug"} \
                ${optionalString cfg.dhcpNoBind "--dhcp-no-bind"} \
                --listen-addr ${lib.escapeShellArg cfg.listen} \
                --port ${toString cfg.port} \
                --status-port ${toString cfg.statusPort} \
                ${escapeShellArgs cfg.extraArguments}
              '';
      };
    };
  };
}

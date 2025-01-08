{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pixiecore;
in
{
  meta.maintainers = with lib.maintainers; [ bbigras ];

  options = {
    services.pixiecore = {
      enable = lib.mkEnableOption "Pixiecore";

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports (67, 69, 4011 UDP and 'port', 'statusPort' TCP) in the firewall for Pixiecore.
        '';
      };

      mode = lib.mkOption {
        description = "Which mode to use";
        default = "boot";
        type = lib.types.enum [
          "api"
          "boot"
          "quick"
        ];
      };

      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Log more things that aren't directly related to booting a recognized client";
      };

      dhcpNoBind = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Handle DHCP traffic without binding to the DHCP server port";
      };

      quick = lib.mkOption {
        description = "Which quick option to use";
        default = "xyz";
        type = lib.types.enum [
          "arch"
          "centos"
          "coreos"
          "debian"
          "fedora"
          "ubuntu"
          "xyz"
        ];
      };

      kernel = lib.mkOption {
        type = lib.types.str or lib.types.path;
        default = "";
        description = "Kernel path. Ignored unless mode is set to 'boot'";
      };

      initrd = lib.mkOption {
        type = lib.types.str or lib.types.path;
        default = "";
        description = "Initrd path. Ignored unless mode is set to 'boot'";
      };

      cmdLine = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Kernel commandline arguments. Ignored unless mode is set to 'boot'";
      };

      listen = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "IPv4 address to listen on";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 80;
        description = "Port to listen on for HTTP";
      };

      statusPort = lib.mkOption {
        type = lib.types.port;
        default = 80;
        description = "HTTP port for status information (can be the same as --port)";
      };

      apiServer = lib.mkOption {
        type = lib.types.str;
        example = "http://localhost:8080";
        description = "URI to connect to the API. Ignored unless mode is set to 'api'";
      };

      extraArguments = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional command line arguments to pass to Pixiecore";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.pixiecore = { };
    users.users.pixiecore = {
      description = "Pixiecore daemon user";
      group = "pixiecore";
      isSystemUser = true;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.port
        cfg.statusPort
      ];
      allowedUDPPorts = [
        67
        69
        4011
      ];
    };

    systemd.services.pixiecore = {
      description = "Pixiecore server";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "pixiecore";
        Restart = "always";
        AmbientCapabilities = [ "cap_net_bind_service" ] ++ lib.optional cfg.dhcpNoBind "cap_net_raw";
        ExecStart =
          let
            argString =
              if cfg.mode == "boot" then
                [
                  "boot"
                  cfg.kernel
                ]
                ++ lib.optional (cfg.initrd != "") cfg.initrd
                ++ lib.optionals (cfg.cmdLine != "") [
                  "--cmdline"
                  cfg.cmdLine
                ]
              else if cfg.mode == "quick" then
                [
                  "quick"
                  cfg.quick
                ]
              else
                [
                  "api"
                  cfg.apiServer
                ];
          in
          ''
            ${pkgs.pixiecore}/bin/pixiecore \
              ${lib.escapeShellArgs argString} \
              ${lib.optionalString cfg.debug "--debug"} \
              ${lib.optionalString cfg.dhcpNoBind "--dhcp-no-bind"} \
              --listen-addr ${lib.escapeShellArg cfg.listen} \
              --port ${toString cfg.port} \
              --status-port ${toString cfg.statusPort} \
              ${lib.escapeShellArgs cfg.extraArguments}
          '';
      };
    };
  };
}

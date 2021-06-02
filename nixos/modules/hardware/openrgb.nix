{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.openrgb;
in

{
  options.programs.openrgb = {
    enable = mkEnableOption ''
      OpenRGB support. Will install udev rules to allow for more devices
      to be shown, and optionally run OpenRGB as a server
    '';

    package = mkOption {
      type = types.package;
      default = pkgs.openrgb;
      description = "OpenRGB package to use for both client and potentially server.";
    };

    server.enable = mkEnableOption ''
      OpenRGB server. OpenRGB will start as a system process, and launching
      the OpenRGB client will attempt to connect to this server. This is
      advantageous as users do not need to run OpenRGB with superuser
      privileges to edit RGB settings in this case
    '';

    server.port = mkOption {
      type = types.port;
      default = 6742;
      example = 7575;
      description = "The port the OpenRGB server will listen.";
    };
  };

  config = mkIf (cfg.enable || cfg.server.enable) {

    # enable more RGB devices to be found
    services.udev.packages = [ cfg.package ];

    environment.systemPackages = [ cfg.package ];

  } // (mkIf cfg.server.enable) {
    # should be ran as root, to have write access to hardware
    systemd.services.openrgb = {
      description = "OpenRGB server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/openrgb --server --server-port ${toString cfg.server.port}";
        Restart = "always";
      };
    };
  };

  meta.maintainers = [ maintainers.jonringer ];

}

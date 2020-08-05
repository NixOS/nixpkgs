{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.hardware.spacenavd;
in
{
  options.hardware.spacenavd = {
    enable = mkOption {
      default = false;
      example = true;
      description = ''
        Whether to enable spacenavd, a daemon which interprets the input from
        3D mice in supported applications (Blender and OpenSCAD).
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.spacenavd = {
      description = "Space Navigator 3D mice driver";
      wantedBy = [ "multi-user.target" ];
      partOf = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.spacenavd}/bin/spacenavd -d";
      };
    };
  };
}

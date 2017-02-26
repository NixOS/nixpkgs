{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.fractalart;
in {
  options.services.fractalart = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable FractalArt for generating colorful wallpapers on login";
    };

    width = mkOption {
      type = types.int;
      default = 1920;
      description = "Screen width";
    };

    height = mkOption {
      type = types.int;
      default = 1080;
      description = "Screen height";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.haskellPackages.FractalArt ];
    systemd.user.services.fractalart = {
      before = [ "display-manager.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.haskellPackages.FractalArt}/bin/FractalArt --no-bg -w ${toString cfg.width} -h ${toString cfg.height} -f .background-image";
      };
    };
  };
}

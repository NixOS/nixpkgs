{ config, lib, pkgs, ... }:
let
  cfg = config.programs.quark-goldleaf;
in
{
  options = {
    programs.quark-goldleaf = {
      enable = lib.mkEnableOption "quark-goldleaf with udev rules applied";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.quark-goldleaf ];
    services.udev.packages = [ pkgs.quark-goldleaf ];
  };

  meta.maintainers = pkgs.quark-goldleaf.meta.maintainers;
}

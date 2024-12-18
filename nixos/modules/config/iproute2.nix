{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.iproute2;
in
{
  options.networking.iproute2 = {
    enable = mkEnableOption "copying IP route configuration files";
    rttablesExtraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Verbatim lines to add to /etc/iproute2/rt_tables
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."iproute2/rt_tables.d/nixos.conf" = {
      mode = "0644";
      text = cfg.rttablesExtraConfig;
    };
  };
}

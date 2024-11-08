{ config, lib, pkgs, ... }:
let
  cfg = config.networking.iproute2;
in
{
  options.networking.iproute2 = {
    enable = lib.mkEnableOption "copying IP route configuration files";
    rttablesExtraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Verbatim lines to add to /etc/iproute2/rt_tables
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."iproute2/rt_tables.d/nixos.conf" = {
      mode = "0644";
      text = cfg.rttablesExtraConfig;
    };
  };
}

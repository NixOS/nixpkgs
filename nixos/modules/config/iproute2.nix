{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.iproute2;
in
{
  options.networking.iproute2 = {
    enable = mkEnableOption (lib.mdDoc "copying IP route configuration files");
    rttablesExtraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Verbatim lines to add to /etc/iproute2/rt_tables
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."iproute2/rt_tables" = {
      mode = "0644";
      text = (fileContents "${pkgs.iproute2}/lib/iproute2/rt_tables")
        + (optionalString (cfg.rttablesExtraConfig != "") "\n\n${cfg.rttablesExtraConfig}");
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
let
  name = "networkaudiod";
  cfg = config.services.networkaudiod;
in
{
  options = {
    services.networkaudiod = {
      enable = lib.mkEnableOption "Networkaudiod (NAA)";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ pkgs.networkaudiod ];
    systemd.services.networkaudiod.wantedBy = [ "multi-user.target" ];
  };
}

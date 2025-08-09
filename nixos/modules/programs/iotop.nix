{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.iotop;
in
{
  options = {
    programs.iotop = {
      enable = lib.mkEnableOption "iotop + setcap wrapper";
      package = lib.mkPackageOption pkgs "iotop" { example = "iotop-c"; };
    };
  };
  config = lib.mkIf cfg.enable {
    security.wrappers.iotop = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin+p";
      source = lib.getExe cfg.package;
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.iftop;
in
{
  meta.maintainers = [ lib.maintainers.booxter ];

  options = {
    programs.iftop.enable = lib.mkEnableOption "iftop and setcap wrapper for it";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.iftop ];
    security.wrappers.iftop = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = lib.getExe pkgs.iftop;
    };
  };
}

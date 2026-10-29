{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.programs.trippy;
in

{
  options = {
    programs.trippy = {
      enable = lib.mkEnableOption "trippy, a network diagnostic tool";
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.trip = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+p";
      source = lib.getExe pkgs.trippy;
    };
  };

  meta.maintainers = [ ];
}

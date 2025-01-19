{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.spacenavd;
in
{
  options = {
    hardware.spacenavd = {
      enable = lib.mkEnableOption "spacenavd to support 3DConnexion devices";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      packages = [ pkgs.spacenavd ];
      services.spacenavd.enable = true;
    };
  };
}

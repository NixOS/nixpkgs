{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.qdmr;
in {
  meta.maintainers = [ lib.maintainers.janik ];

  options = {
    programs.qdmr = {
      enable = lib.mkEnableOption (lib.mdDoc "QDMR - a GUI application and command line tool for programming DMR radios");
      package = lib.mkPackageOption pkgs "qdmr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
    users.groups.dialout = {};
  };
}

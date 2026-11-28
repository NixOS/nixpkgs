{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.septabee;
in

{
  options = {
    programs.septabee = {
      enable = lib.mkEnableOption "SEPTABEE with proper capabilities for realtime threads";
      package = lib.mkPackageOption pkgs "septabee" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.septabee = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_nice+ep";
      source = "${lib.getExe cfg.package}";
    };
  };
}

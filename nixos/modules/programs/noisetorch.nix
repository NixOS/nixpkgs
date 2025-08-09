{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.noisetorch;
in
{
  options.programs.noisetorch = {
    enable = lib.mkEnableOption "noisetorch (+ setcap wrapper), a virtual microphone device with noise suppression";

    package = lib.mkPackageOption pkgs "noisetorch" { };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.noisetorch = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_resource=+ep";
      source = "${cfg.package}/bin/noisetorch";
    };
    environment.systemPackages = [ cfg.package ];
  };
}

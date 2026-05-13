{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.probe-rs-tools;
in
{
  options = {
    programs.probe-rs-tools = {
      enable = lib.mkEnableOption "probe-rs-tools with udev rules applied";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.probe-rs-tools ];
    services.udev.packages = [ pkgs.probe-rs-tools ];

    users.groups.plugdev = { };
  };

  meta.maintainers = pkgs.probe-rs-tools.meta.maintainers;
}

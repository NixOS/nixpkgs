{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = maintainers.fabianhauser;

  options.programs.hamster.enable =
    mkEnableOption "Whether to enable hamster time tracking.";

  config = lib.mkIf config.programs.hamster.enable {
    environment.systemPackages = [ pkgs.hamster ];
    services.dbus.packages = [ pkgs.hamster ];
  };
}

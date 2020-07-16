{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = pkgs.hamster.meta.maintainers;

  options.programs.hamster.enable =
    mkEnableOption "Whether to enable hamster time tracking.";

  config = lib.mkIf config.programs.hamster.enable {
    environment.systemPackages = [ pkgs.hamster ];
    services.dbus.packages = [ pkgs.hamster ];
  };
}

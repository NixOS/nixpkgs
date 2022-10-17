{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = pkgs.hamster.meta.maintainers;

  options.programs.hamster.enable =
    mkEnableOption (lib.mdDoc "hamster, a time tracking program");

  config = lib.mkIf config.programs.hamster.enable {
    environment.systemPackages = [ pkgs.hamster ];
    services.dbus.packages = [ pkgs.hamster ];
  };
}

{ config, pkgs, lib, ... }:

let
  cfg = config.programs.nautilus;
  package = pkgs.nautilus.override { nautilusExtensions = cfg.extensions; };
in

{
  meta = {
    maintainers = pkgs.nautilus.meta.members;
  };

  options = {
    programs.nautilus = {
      enable = lib.mkEnableOption "Nautilus file manager";

      extensions = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.package;
        description = "List of Nautilus extensions to install.";
        example = lib.literalExpression "[ pkgs.nautilus-python ]";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    services.dbus.packages = [ package ];

    environment.pathsToLink = [
      "/share/nautilus-python/extensions"
    ];
  };
}

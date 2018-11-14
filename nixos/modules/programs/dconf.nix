{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dconf;

  mkDconfProfile = name: path:
    { source = path; target = "dconf/profile/${name}"; };

in
{
  ###### interface

  options = {
    programs.dconf = {
      enable = mkEnableOption "dconf";

      profiles = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = "Set of dconf profile files.";
        internal = true;
      };

    };
  };

  ###### implementation

  config = mkIf (cfg.profiles != {} || cfg.enable) {
    environment.etc = optionals (cfg.profiles != {})
      (mapAttrsToList mkDconfProfile cfg.profiles);

    services.dbus.packages = [ pkgs.gnome3.dconf ];

    environment.variables.GIO_EXTRA_MODULES = optional cfg.enable
      "${pkgs.gnome3.dconf.lib}/lib/gio/modules";
    # https://github.com/NixOS/nixpkgs/pull/31891
    #environment.variables.XDG_DATA_DIRS = optional cfg.enable
    #  "$(echo ${pkgs.gnome3.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-*)";
  };

}

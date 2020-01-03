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

    services.dbus.packages = [ pkgs.dconf ];

    # For dconf executable
    environment.systemPackages = [ pkgs.dconf ];

    # Needed for unwrapped applications
    environment.variables.GIO_EXTRA_MODULES = mkIf cfg.enable [ "${pkgs.dconf.lib}/lib/gio/modules" ];
  };

}

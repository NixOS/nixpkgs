{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.dconf;
  cfgDir = pkgs.symlinkJoin {
    name = "dconf-system-config";
    paths = map (x: "${x}/etc/dconf") cfg.packages;
    postBuild = ''
      mkdir -p $out/profile
      mkdir -p $out/db
    '' + (
      concatStringsSep "\n" (
        mapAttrsToList (
          name: path: ''
            ln -s ${path} $out/profile/${name}
          ''
        ) cfg.profiles
      )
    ) + ''
      ${pkgs.dconf}/bin/dconf update $out/db
    '';
  };
in
{
  ###### interface

  options = {
    programs.dconf = {
      enable = mkEnableOption (lib.mdDoc "dconf");

      profiles = mkOption {
        type = types.attrsOf types.path;
        default = {};
        description = lib.mdDoc "Set of dconf profile files, installed at {file}`/etc/dconf/profiles/«name»`.";
        internal = true;
      };

      packages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = lib.mdDoc "A list of packages which provide dconf profiles and databases in {file}`/etc/dconf`.";
      };
    };
  };

  ###### implementation

  config = mkIf (cfg.profiles != {} || cfg.enable) {
    environment.etc.dconf = mkIf (cfg.profiles != {} || cfg.packages != []) {
      source = cfgDir;
    };

    services.dbus.packages = [ pkgs.dconf ];

    systemd.packages = [ pkgs.dconf ];

    # For dconf executable
    environment.systemPackages = [ pkgs.dconf ];

    # Needed for unwrapped applications
    environment.sessionVariables.GIO_EXTRA_MODULES = mkIf cfg.enable [ "${pkgs.dconf.lib}/lib/gio/modules" ];
  };

}

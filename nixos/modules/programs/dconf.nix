{ config, lib, pkgs, ... }:

let
  cfg = config.programs.dconf;

  # Generate dconf profile
  mkDconfProfile = name: value:
    pkgs.runCommand "dconf-profile" { } ''
      mkdir -p $out/etc/dconf/profile/
      cp ${value} $out/etc/dconf/profile/${name}
    '';
in
{
  options = {
    programs.dconf = {
      enable = lib.mkEnableOption (lib.mdDoc "dconf");

      profiles = lib.mkOption {
        type = with lib.types; attrsOf (oneOf [
          path
          package
        ]);
        description = lib.mdDoc "Attrset of dconf profiles.";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = lib.mdDoc "A list of packages which provide dconf profiles and databases in {file}`/etc/dconf`.";
      };
    };
  };

  config = lib.mkIf (cfg.profiles != { } || cfg.enable) {
    programs.dconf.packages = lib.mapAttrsToList mkDconfProfile cfg.profiles;

    environment.etc.dconf = lib.mkIf (cfg.packages != [ ]) {
      source = pkgs.symlinkJoin {
        name = "dconf-system-config";
        paths = map (x: "${x}/etc/dconf") cfg.packages;
        nativeBuildInputs = [ (lib.getBin pkgs.dconf) ];
        postBuild = ''
          if test -d $out/db; then
            dconf update $out/db
          fi
        '';
      };
    };

    services.dbus.packages = [ pkgs.dconf ];

    systemd.packages = [ pkgs.dconf ];

    # For dconf executable
    environment.systemPackages = [ pkgs.dconf ];

    environment.sessionVariables = lib.mkIf cfg.enable {
      # Needed for unwrapped applications
      GIO_EXTRA_MODULES = [ "${pkgs.dconf.lib}/lib/gio/modules" ];
    };
  };
}

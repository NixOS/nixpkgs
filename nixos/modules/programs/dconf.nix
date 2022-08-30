{ config, lib, pkgs, ... }:

let
  cfg = config.programs.dconf;

  asFileDb = val:
    let db =
      if lib.isAttrs val && !lib.isDerivation val then
        pkgs.dconf-utils.mkDconfDb "${pkgs.writeTextDir "dconf/db" (lib.generators.toDconfINI val)}/dconf"
      else val;
    in "file-db:${db}";
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "dconf" "packages" ] "This option is not supported anymore, you should use `programs.dconf.profiles.<profile>.databases` instead.")
  ];

  options = {
    programs.dconf = {
      enable = lib.mkEnableOption (lib.mdDoc "dconf");

      profiles = lib.mkOption {
        type = with lib.types; attrsOf (submodule {
          options = {
            enableUserDb = lib.mkOption {
              type = bool;
              default = true;
              description = lib.mdDoc "Add `user-db:user` at the beginning of the profile.";
            };

            databases = lib.mkOption {
              type = with lib.types; listOf (oneOf [ attrs str path package ]);
              default = [];
              description = lib.mdDoc "List of data sources for the profile. An element can be an attrset, or the path of an already compiled database.";
            };
          };
        });
        description = lib.mdDoc "Attrset of dconf profiles.";
      };

      defaultProfile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = lib.mdDoc "The default dconf profile.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc = lib.attrsets.mapAttrs' (name: value: lib.nameValuePair "dconf/profile/${name}" {
      text = lib.concatMapStrings (x: "${x}\n") ((lib.optional value.enableUserDb "user-db:user") ++ (map asFileDb value.databases));
    }) cfg.profiles;

    services.dbus.packages = [ pkgs.dconf ];

    systemd.packages = [ pkgs.dconf ];

    # For dconf executable
    environment.systemPackages = [ pkgs.dconf ];

    environment.sessionVariables = {
      # Needed for unwrapped applications
      GIO_EXTRA_MODULES = [ "${pkgs.dconf.lib}/lib/gio/modules" ];
    } // (if cfg.defaultProfile != null then { DCONF_PROFILE = cfg.defaultProfile; } else {});
  };
}

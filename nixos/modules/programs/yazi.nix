{ config, lib, pkgs, ... }:

let
  cfg = config.programs.yazi;

  settingsFormat = pkgs.formats.toml { };

  files = [ "yazi" "theme" "keymap" ];

  dirs = [ "plugins" "flavors" ];
in
{
  options.programs.yazi = {
    enable = lib.mkEnableOption "yazi terminal file manager";

    package = lib.mkPackageOption pkgs "yazi" { };

    settings = lib.mkOption {
      type = with lib.types; submodule {
        options = (lib.listToAttrs (map
          (name: lib.nameValuePair name (lib.mkOption {
            inherit (settingsFormat) type;
            default = { };
            description = ''
              Configuration included in `${name}.toml`.

              See https://yazi-rs.github.io/docs/configuration/${name}/ for documentation.
            '';
          }))
          files));
      };
      default = { };
      description = ''
        Configuration included in `$YAZI_CONFIG_HOME`.
      '';
    };

    initLua = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = ''
        The init.lua for Yazi itself.
      '';
    };

  } // (lib.listToAttrs (map
    (name: lib.nameValuePair name (lib.mkOption {
      type = with lib.types; attrsOf (oneOf [ path package ]);
      default = { };
      description = ''
        Lua plugins.

        See https://yazi-rs.github.io/docs/${name}/overview/ for documentation.
      '';
    }))
    dirs)
  );

    flavors = lib.mkOption {
      type = with lib.types; attrsOf (oneOf [ path package ]);
      default = { };
      description = ''
        Pre-made themes.

        See https://yazi-rs.github.io/docs/flavors/overview/ for documentation.
      '';
      example = lib.literalExpression ''
        {
          foo = ./foo;
          bar = pkgs.bar;
        }
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      variables.YAZI_CONFIG_HOME = "/etc/yazi/";
      etc = (lib.attrsets.mergeAttrsList (map
        (name: lib.optionalAttrs (cfg.settings.${name} != { }) {
          "yazi/${name}.toml".source = settingsFormat.generate "${name}.toml" cfg.settings.${name};
        })
        files)) // (lib.attrsets.mergeAttrsList (map
        (dir:
          if cfg.${dir} != { } then
            (lib.mapAttrs'
              (name: value: lib.nameValuePair "yazi/${dir}/${name}" { source = value; })
              cfg.${dir}) else {
            # Yazi checks the directories. If they don't exist it tries to create them and then crashes.
            "yazi/${dir}".source = pkgs.emptyDirectory;
          })
        dirs)) // lib.optionalAttrs (cfg.initLua != null) {
        "yazi/init.lua".source = cfg.initLua;
      };
    };
  };
  meta = {
    maintainers = with lib.maintainers; [ linsui ];
  };
}

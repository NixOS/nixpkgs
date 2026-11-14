{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.yazi;

  settingsFormat = pkgs.formats.toml { };

  files = [
    "yazi"
    "theme"
    "keymap"
    "vfs"
  ];
in
{
  options.programs.yazi = {
    enable = lib.mkEnableOption "yazi terminal file manager";

    package = lib.mkPackageOption pkgs "yazi" { };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      default = cfg.package.override {
        inherit (cfg)
          settings
          initLua
          plugins
          flavors
          ;
      };
      visible = false;
      readOnly = true;
      description = "The resulting yazi package, bundled with settings, initLua, plugins and flavors";
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        submodule {
          options = lib.genAttrs files (
            name:
            lib.mkOption {
              inherit (settingsFormat) type;
              default = { };
              description = ''
                Configuration included in `${name}.toml`.

                See <https://yazi-rs.github.io/docs/configuration/${name}/> for documentation.
              '';
            }
          );
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
      example = lib.literalExpression "./init.lua";
    };

    plugins = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          path
          package
        ]);
      default = { };
      description = ''
        Lua plugins.

        See <https://yazi-rs.github.io/docs/plugins/overview/> for documentation.
      '';
      example = lib.literalExpression ''
        {
          foo = ./foo;
          inherit (pkgs.yaziPlugins) bar;
        }
      '';
    };

    flavors = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          path
          package
        ]);
      default = { };
      description = ''
        Pre-made themes.

        See <https://yazi-rs.github.io/docs/flavors/overview/> for documentation.
      '';
      example = lib.literalExpression ''
        {
          foo = ./foo;
          inherit (pkgs.yaziPlugins) bar;
        }
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];
  };

  meta = {
    maintainers = with lib.maintainers; [
      linsui
      ryan4yin
    ];
  };
}

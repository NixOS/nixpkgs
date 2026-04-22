{ config, lib, ... }:
let
  /*
    transform all plugins into an attrset
    { optional = bool; plugin = package; }
  */
  normalizePlugins =
    plugins:
    let
      defaultPlugin = {
        plugin = null;
        config = null;
        optional = false;
        type = "viml";
      };
    in
    map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; })) plugins;

  pluginWithConfigType =
    with lib;
    types.submodule {
      options = {
        config = mkOption {
          type = types.nullOr types.lines;
          description = "viml configuration associated with this plugin.";
          default = null;
          example = "set title";
        };

        type = lib.mkOption {
          type = lib.types.either (lib.types.enum [
            "lua"
            "viml"
          ]) lib.types.str;
          description = "Language used in config. Configurations are aggregated per-language.";
          default = "viml";
        };

        optional = mkEnableOption "optional" // {
          description = "Don't load automatically on startup (load with :packadd)";
        };

        plugin = mkOption {
          type = types.package;
          example = lib.literalExpression "vimPlugins.vim-fugitive";
          description = "vim plugin";
        };
      };
    };

in
{
  options = {
    plugins = lib.mkOption {
      type = with lib.types; listOf (either package pluginWithConfigType);
      default = [ ];
      apply = normalizePlugins;
      example = lib.literalExpression ''
        with pkgs.vimPlugins; [
          yankring
          vim-nix
          { plugin = vim-startify;
            config = "let g:startify_change_to_vcs_root = 0";
          }
        ]
      '';
      description = ''
        List of vim plugins to install optionally associated with
        configuration to be placed in init.vim.
      '';
    };

    runtimeDeps = lib.mkOption {
      readOnly = true;
      type = with lib.types; listOf package;
      description = ''
        List of derivations required at runtime
      '';
    };

    pluginAdvisedLua = lib.mkOption {
      readOnly = true;
      type = lib.types.listOf lib.types.lines;
      description = ''
        Recommended configuration set in vim plugins via ".passthru.initLua".
      '';
    };

    userPluginViml = lib.mkOption {
      readOnly = true;
      type = lib.types.nullOr lib.types.lines;
      description = ''
        The viml config set by the user.
      '';
    };

    userPluginConfigs = lib.mkOption {
      readOnly = true;
      type = lib.types.attrsOf lib.types.lines;
      description = ''
        The user configurations (viml, lua, ...) set by the user.
      '';
    };

    pluginPython3Packages = lib.mkOption {
      readOnly = true;
      type = lib.types.listOf (lib.types.functionTo (lib.types.listOf lib.types.package));
      example = lib.literalExpression "[ (ps: [ ps.python-language-server ]) ]";
      description = ''
        Packages required by the plugins to work with the python3 provider.
      '';
    };

    luaDependencies = lib.mkOption {
      readOnly = true;
      type = lib.types.listOf (lib.types.nullOr lib.types.package);
      example = lib.literalExpression "[ (lp: [ lp.mpack ]) ]";
      description = ''
        Lua dependencies required by the plugins.
      '';
    };
  };

  config =
    let
      pluginsNormalized = config.plugins;

      userPluginConfigs =
        let
          grouped = lib.groupBy (x: x.type) pluginsNormalized;
          configsOnly = lib.foldl (acc: p: if p.config != null then acc ++ [ p.config ] else acc) [ ];
        in
        lib.mapAttrs (_name: vals: lib.concatStringsSep "\n" (configsOnly vals)) grouped;
    in
    {
      pluginAdvisedLua =
        let
          op =
            acc: normalizedPlugin:
            acc
            ++ lib.optional (
              normalizedPlugin.plugin.passthru ? initLua
            ) normalizedPlugin.plugin.passthru.initLua;
        in
        lib.foldl' op [ ] pluginsNormalized;

      runtimeDeps =
        let
          op = acc: normalizedPlugin: acc ++ normalizedPlugin.plugin.runtimeDeps or [ ];
        in
        lib.foldl' op [ ] pluginsNormalized;

      userPluginViml = userPluginConfigs.viml or null;

      inherit userPluginConfigs;

      pluginPython3Packages = map (plugin: plugin.python3Dependencies or (_: [ ])) pluginsNormalized;

      luaDependencies =
        let
          op = acc: p: acc ++ (p.plugin.requiredLuaModules or [ ]);
        in
        lib.foldl' op [ ] pluginsNormalized;
    };
}

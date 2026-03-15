{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    mkMerge
    literalExpression
    ;
  inherit (lib.types)
    listOf
    str
    bool
    int
    enum
    nullOr
    oneOf
    attrsOf
    either
    types
    ;
  inherit (lib.strings) escapeShellArgs;

  cfg = config.programs.atuin;

  tomlFormat = pkgs.formats.toml { };

  settingsFile = tomlFormat.generate "atuin-config" cfg.settings;
in
{
  options.programs.atuin = {
    enable = mkEnableOption "atuin";

    package = mkPackageOption pkgs "atuin" { };

    enableBashIntegration = mkEnableOption "Bash integration";

    enableZshIntegration = mkEnableOption "Zsh integration";

    enableFishIntegration = mkEnableOption "Fish integration";

    flags = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "--disable-up-arrow"
        "--disable-ctrl-r"
      ];
      description = ''
        Flags to append to the shell hook.
      '';
    };

    settings = mkOption {
      type =
        let
          prim = oneOf [
            bool
            int
            str
          ];
          primOrPrimAttrs = either prim (attrsOf prim);
          entry = either prim (listOf primOrPrimAttrs);
          entryOrAttrsOf = t: either entry (attrsOf t);
          entries = entryOrAttrsOf (entryOrAttrsOf entry);
        in
        attrsOf entries // { description = "Atuin configuration"; };
      default = { };
      example = literalExpression ''
        {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://api.atuin.sh";
          search_mode = "prefix";
        }
      '';
      description = ''
        Configuration written to {file}`$XDG_CONFIG_HOME/atuin/config.toml`.

        See <https://docs.atuin.sh/configuration/config/> for the full list
        of options.
      '';
    };

    forceOverwriteSettings = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When enabled, force overwriting of the Atuin configuration file
        ({file}`$XDG_CONFIG_HOME/atuin/config.toml`).
        Any existing Atuin configuration will be lost.

        Enabling this is useful when adding settings for the first time
        because Atuin writes its default config file after every single
        shell command, which can make it difficult to manually remove.
      '';
    };

    themes = mkOption {
      type = types.attrsOf (
        types.oneOf [
          tomlFormat.type
          types.path
          types.lines
        ]
      );
      description = ''
        Each theme is written to
        {file}`$XDG_CONFIG_HOME/atuin/themes/theme-name.toml`
        where the name of each attribute is the theme-name

        See <https://docs.atuin.sh/guide/theming/> for the full list
        of options.
      '';
      default = { };
      example = literalExpression ''
        {
          "my-theme" = {
            theme.name = "My Theme";
            colors = {
              Base = "#000000";
              Title = "#FFFFFF";
            };
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ cfg.package ];

      environment.etc = mkMerge [
        (mkIf (cfg.settings != { }) {
          "xdg/atuin/config.toml" = {
            source = settingsFile;
            force = cfg.forceOverwriteSettings;
          };
        })

        (mkIf (cfg.themes != { }) (
          builtins.mapAttrs' (
            name: theme:
            lib.nameValuePair "xdg/atuin/themes/${name}.toml" {
              source =
                if builtins.isString theme then
                  pkgs.writeText "atuin-theme-${name}" theme
                else if builtins.isPath theme || lib.isStorePath theme then
                  theme
                else
                  tomlFormat.generate "atuin-theme-${name}" theme;
            }
          ) cfg.themes
        ))
      ];
    }

    (mkIf cfg.enableBashIntegration {
      programs.bash.interactiveShellInit = ''
        if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
          eval "$(${lib.getExe cfg.package} init bash ${escapeShellArgs cfg.flags})"
        fi
      '';
    })

    (mkIf cfg.enableZshIntegration {
      programs.zsh.interactiveShellInit = ''
        if [[ $options[zle] = on ]]; then
          eval "$(${lib.getExe cfg.package} init zsh ${escapeShellArgs cfg.flags})"
        fi
      '';
    })

    (mkIf cfg.enableFishIntegration {
      programs.fish.interactiveShellInit = ''
        ${lib.getExe cfg.package} init fish ${escapeShellArgs cfg.flags} | source
      '';
    })
  ]);

  meta.maintainers = cfg.package.meta.maintainers;
}

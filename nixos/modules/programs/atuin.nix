{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) escapeShellArgs;

  cfg = config.programs.atuin;

  tomlFormat = pkgs.formats.toml { };

  settingsFile = tomlFormat.generate "atuin-config" cfg.settings;
in
{
  options.programs.atuin = {
    enable = lib.mkEnableOption "atuin";

    package = lib.mkPackageOption pkgs "atuin" { };

    enableBashIntegration = lib.mkEnableOption "Bash integration" // {
      default = config.programs.bash.enable;
      defaultText = lib.literalExpression "config.programs.bash.enable";
    };

    enableZshIntegration = lib.mkEnableOption "Zsh integration" // {
      default = config.programs.zsh.enable;
      defaultText = lib.literalExpression "config.programs.zsh.enable";
    };

    enableFishIntegration = lib.mkEnableOption "Fish integration" // {
      default = config.programs.fish.enable;
      defaultText = lib.literalExpression "config.programs.fish.enable";
    };

    flags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--disable-up-arrow"
        "--disable-ctrl-r"
      ];
      description = ''
        Flags to append to the shell hook.
      '';
    };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          auto_sync = true;
          sync_frequency = "5m";
          sync_address = "https://api.atuin.sh";
          search_mode = "prefix";
        }
      '';
      description = ''
        Configuration written to {file}`/etc/atuin/config.toml`.

        See <https://docs.atuin.sh/configuration/config/> for the full list
        of options.
      '';
    };

    daemon = {
      enable = lib.mkEnableOption "the Atuin daemon" // {
        default = pkgs.stdenv.hostPlatform.isLinux;
        defaultText = lib.literalExpression "pkgs.stdenv.hostPlatform.isLinux";
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "trace"
          "debug"
          "info"
          "warn"
          "error"
        ];
        default = "info";
        description = ''
          Log level for the Atuin daemon.
        '';
      };
    };

    themes = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          tomlFormat.type
          lib.types.path
          lib.types.lines
        ]
      );
      description = ''
        Each theme is written to
        {file}`/etc/atuin/themes/theme-name.toml`
        where the name of each attribute is the theme-name

        See <https://docs.atuin.sh/guide/theming/> for the full list
        of options.
      '';
      default = { };
      example = lib.literalExpression ''
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

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Atuin only reads from ATUIN_CONFIG_DIR or XDG_CONFIG_HOME, not XDG_CONFIG_DIRS,
    # so we must set ATUIN_CONFIG_DIR to point to the system-wide config location.
    environment.variables.ATUIN_CONFIG_DIR = "/etc/atuin";

    environment.etc = lib.mkMerge [
      (lib.mkIf (cfg.settings != { }) {
        "atuin/config.toml".source = settingsFile;
      })

      (lib.mkIf (cfg.themes != { }) (
        builtins.mapAttrs' (
          name: theme:
          lib.nameValuePair "atuin/themes/${name}.toml" {
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

    programs.bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        eval "$(${lib.getExe cfg.package} init bash ${escapeShellArgs cfg.flags})"
      fi
    '';

    programs.zsh.interactiveShellInit = lib.mkIf cfg.enableZshIntegration ''
      if [[ $options[zle] = on ]]; then
        eval "$(${lib.getExe cfg.package} init zsh ${escapeShellArgs cfg.flags})"
      fi
    '';

    programs.fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration ''
      ${lib.getExe cfg.package} init fish ${escapeShellArgs cfg.flags} | source
    '';

    systemd = lib.mkIf (cfg.daemon.enable && pkgs.stdenv.hostPlatform.isLinux) {
      user.services.atuin-daemon = {
        unitConfig = {
          Description = "Atuin daemon";
          Requires = [ "atuin-daemon.socket" ];
        };
        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} daemon start";
          Environment = [ "ATUIN_LOG=${cfg.daemon.logLevel}" ];
          Restart = "on-failure";
          RestartSteps = 3;
          RestartMaxDelaySec = 6;
        };
      };

      user.sockets.atuin-daemon = {
        unitConfig = {
          Description = "Atuin daemon socket";
        };
        socketConfig = {
          ListenStream = "%t/atuin/atuin.sock";
          SocketMode = "0640";
          DirectoryMode = "0740";
          RemoveOnStop = true;
        };
        wantedBy = [ "sockets.target" ];
      };
    };
  };

  meta.maintainers = cfg.package.meta.maintainers;
}

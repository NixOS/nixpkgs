{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.hm.nushell) isNushellInline toNushell;
  cfg = config.programs.nushell;

  configDir =
    if pkgs.stdenv.isDarwin && !config.xdg.enable then
      "Library/Application Support/nushell"
    else
      "${config.xdg.configHome}/nushell";

  linesOrSource =
    name:
    types.submodule (
      { config, ... }:
      {
        options = {
          text = lib.mkOption {
            type = types.lines;
            default = if config.source != null then builtins.readFile config.source else "";
            defaultText = lib.literalExpression "if source is defined, the content of source, otherwise empty";
            description = ''
              Text of the nushell {file}`${name}` file.
              If unset then the source option will be preferred.
            '';
          };

          source = lib.mkOption {
            type = types.nullOr types.path;
            default = null;
            description = ''
              Path of the nushell {file}`${name}` file to use.
              If the text option is set, it will be preferred.
            '';
          };
        };
      }
    );
in
{
  meta.maintainers = with lib.maintainers; [ guelakais ];

  options.programs.nushell = {
    enable = lib.mkEnableOption "nushell";

    package = lib.mkPackageOption pkgs "nushell" { nullable = true; };

    configFile = lib.mkOption {
      type = types.nullOr (linesOrSource "config.nu");
      default = null;
      example = lib.literalExpression ''
        {
          text = '''
            const NU_LIB_DIRS = $NU_LIB_DIRS ++ ''${
              lib.hm.nushell.toNushell (lib.concatStringsSep ":" [ ./scripts ])
            }
            $env.config.filesize_metric = false
            $env.config.table_mode = 'rounded'
            $env.config.use_ls_colors = true
          ''';
        }
      '';
      description = ''
        The configuration file to be used for nushell.

        See <https://www.nushell.sh/book/configuration.html#configuration> for more information.
      '';
    };

    envFile = lib.mkOption {
      type = types.nullOr (linesOrSource "env.nu");
      default = null;
      example = ''
        $env.FOO = 'BAR'
      '';
      description = ''
        The environment variables file to be used for nushell.

        See <https://www.nushell.sh/book/configuration.html#configuration> for more information.
      '';
    };

    loginFile = lib.mkOption {
      type = types.nullOr (linesOrSource "login.nu");
      default = null;
      example = ''
        # Prints "Hello, World" upon logging into tty1
        if (tty) == "/dev/tty1" {
          echo "Hello, World"
        }
      '';
      description = ''
        The login file to be used for nushell upon logging in.

        See <https://www.nushell.sh/book/configuration.html#configuring-nu-as-a-login-shell> for more information.
      '';
    };

    extraConfig = lib.mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell configuration file.
      '';
    };

    extraEnv = lib.mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell environment variables file.
      '';
    };

    extraLogin = lib.mkOption {
      type = types.lines;
      default = "";
      description = ''
        Additional configuration to add to the nushell login file.
      '';
    };

    plugins = lib.mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.nushellPlugins.formats ]";
      description = ''
        A list of nushell plugins to write to the plugin registry file.
      '';
    };

    settings = lib.mkOption {
      type = types.attrsOf lib.hm.types.nushellValue;
      default = { };
      example = {
        show_banner = false;
        history.format = "sqlite";
      };
      description = ''
        Nushell settings. These will be flattened and assigned one by one to `$env.config` to avoid overwriting the default or existing options.

        For example:
        ```nix
        {
          show_banner = false;
          completions.external = {
            enable = true;
            max_results = 200;
          };
        }
        ```
        becomes:
        ```nushell
        $env.config.completions.external.enable = true
        $env.config.completions.external.max_results = 200
        $env.config.show_banner = false
        ```
      '';
    };

    shellAliases = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        ll = "ls -l";
        g = "git";
      };
      description = ''
        An attribute set that maps aliases (the top level attribute names in
        this option) to command strings or directly to build outputs.
      '';
    };

    environmentVariables = lib.mkOption {
      type = types.attrsOf lib.hm.types.nushellValue;
      default = { };
      example = lib.literalExpression ''
        {
          FOO = "BAR";
          LIST_VALUE = [ "foo" "bar" ];
          PROMPT_COMMAND = lib.hm.nushell.mkNushellInline '''{|| "> "}''';
          ENV_CONVERSIONS.PATH = {
            from_string = lib.hm.nushell.mkNushellInline "{|s| $s | split row (char esep) }";
            to_string = lib.hm.nushell.mkNushellInline "{|v| $v | str join (char esep) }";
          };
        }
      '';
      description = ''
        Environment variables to be set.

        Inline values can be set with `lib.hm.nushell.mkNushellInline`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (cfg.package == null && cfg.plugins != [ ]) ''
      You have configured `plugins` for `nushell` but have not set `package`.

      The listed plugins will not be installed.
    '';

    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];

    home.extraDependencies = cfg.plugins; # make sure the plugins are not garbage-collected

    home.file = lib.mkMerge [
      (
        let
          writeConfig =
            cfg.configFile != null || cfg.extraConfig != "" || aliasesStr != "" || cfg.settings != { };

          aliasesStr = lib.concatLines (
            lib.mapAttrsToList (k: v: "alias ${toNushell { } k} = ${v}") cfg.shellAliases
          );
        in
        lib.mkIf writeConfig {
          "${configDir}/config.nu".text = lib.mkMerge [
            (
              let
                hasEnvVars = cfg.environmentVariables != { };
                envVarsStr = ''
                  load-env ${toNushell { } cfg.environmentVariables}
                '';
              in
              lib.mkIf hasEnvVars envVarsStr
            )
            (
              let
                flattenSettings =
                  let
                    joinDot = a: b: "${if a == "" then "" else "${a}."}${b}";
                    unravel =
                      prefix: value:
                      if lib.isAttrs value && !isNushellInline value then
                        lib.concatMap (key: unravel (joinDot prefix key) value.${key}) (builtins.attrNames value)
                      else
                        [ (lib.nameValuePair prefix value) ];
                  in
                  unravel "";
                mkLine =
                  { name, value }:
                  ''
                    $env.config.${name} = ${toNushell { } value}
                  '';
                settingsLines = lib.concatMapStrings mkLine (flattenSettings cfg.settings);

              in
              lib.mkIf (cfg.settings != { }) settingsLines
            )
            (lib.mkIf (cfg.configFile != null) cfg.configFile.text)
            cfg.extraConfig
            aliasesStr
          ];
        }
      )

      (lib.mkIf (cfg.envFile != null || cfg.extraEnv != "") {
        "${configDir}/env.nu".text = lib.mkMerge [
          (lib.mkIf (cfg.envFile != null) cfg.envFile.text)
          cfg.extraEnv
        ];
      })
      (lib.mkIf (cfg.loginFile != null || cfg.extraLogin != "") {
        "${configDir}/login.nu".text = lib.mkMerge [
          (lib.mkIf (cfg.loginFile != null) cfg.loginFile.text)
          cfg.extraLogin
        ];
      })

      (
        let
          msgPackz = pkgs.runCommand "nushellMsgPackz" { } ''
            mkdir -p "$out"
            ${lib.getExe cfg.package} \
              --plugin-config "$out/plugin.msgpackz" \
              --commands '${
                lib.concatStringsSep "; " (map (plugin: "plugin add ${lib.getExe plugin}") cfg.plugins)
              }'
          '';
        in
        lib.mkIf ((cfg.package != null) && (cfg.plugins != [ ])) {
          "${configDir}/plugin.msgpackz".source = "${msgPackz}/plugin.msgpackz";
        }
      )
    ];
  };
}

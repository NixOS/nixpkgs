{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    isBool
    listToAttrs
    literalExpression
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalString
    replaceChars
    substring
    toLower
    types
    ;
  inherit (types)
    bool
    either
    listOf
    str
    submodule
    ;

  cfg = config.programs.pay-respects;

  settingsFormat = pkgs.formats.toml { };
  inherit (settingsFormat) generate type;

  finalPackage =
    if cfg.aiIntegration != true then
      (pkgs.runCommand "pay-respects-wrapper"
        {
          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          inherit (cfg.package) meta;
        }
        ''
          mkdir -p $out/bin
          makeWrapper ${getExe cfg.package} $out/bin/${cfg.package.meta.mainProgram} \
            ${optionalString (cfg.aiIntegration == false) "--set _PR_AI_DISABLE true"} \
            ${optionalString (cfg.aiIntegration != false) ''
              --set _PR_AI_URL ${cfg.aiIntegration.url} \
              --set _PR_AI_MODEL ${cfg.aiIntegration.model} \
              --set _PR_AI_LOCALE ${cfg.aiIntegration.locale}
            ''}
        ''
      )
    else
      cfg.package;

  initScript =
    shell:
    if (shell != "fish") then
      ''
        eval "$(${getExe finalPackage} ${shell} --alias ${cfg.alias})"
      ''
    else
      ''
        ${getExe finalPackage} ${shell} --alias ${cfg.alias} | source
      '';
in
{
  options = {
    programs.pay-respects = {
      enable = mkEnableOption "pay-respects, an app which corrects your previous console command";

      package = mkPackageOption pkgs "pay-respects" { };

      alias = mkOption {
        default = "f";
        type = str;
        description = ''
          `pay-respects` needs an alias to be configured.
          The default value is `f`, but you can use anything else as well.
        '';
      };
      runtimeRules = mkOption {
        type = listOf type;
        default = [ ];
        example = literalExpression ''
          [
            {
              command = "xl";
              match_err = [
                {
                  pattern = [
                    "Permission denied"
                  ];
                  suggest = [
                    '''
                      #[executable(sudo), !cmd_contains(sudo), err_contains(libxl: error:)]
                      sudo {{command}}
                    '''
                  ];
                }
              ];
            }
          ];
        '';
        description = ''
          List of rules to be added to `/etc/xdg/pay-respects/rules`.
          `pay-respects` will read the contents of these generated rules to recommend command corrections.
          Each rule module should start with the `command` attribute that specifies the command name. See the [upstream documentation](https://codeberg.org/iff/pay-respects/src/branch/main/rules.md) for more information.
        '';
      };
      aiIntegration = mkOption {
        default = false;
        example = {
          url = "http://127.0.0.1:11434/v1/chat/completions";
          model = "llama3";
          locale = "nl-be";
        };
        description = ''
          Whether to enable `pay-respects`' LLM integration. When there is no rule for a given error, `pay-respects` can query an OpenAI-compatible API endpoint for command corrections.

          - If this is set to `false`, all LLM-related features are disabled.
          - If this is set to `true`, the default OpenAI endpoint will be used, using upstream's API key. This default API key may be rate-limited.
          - You can also set a custom API endpoint, large language model and locale for command corrections. Simply access the `aiIntegration.url`, `aiIntegration.model` and `aiIntegration.locale` options, as described in the example.
            - Take a look at the [services.ollama](#opt-services.ollama.enable) NixOS module if you wish to host a local large language model for `pay-respects`.

          For all of these methods, you can set a custom secret API key by using the `_PR_AI_API_KEY` environment variable.
        '';
        type = either bool (submodule {
          options = {
            url = mkOption {
              default = "";
              example = "https://api.openai.com/v1/chat/completions";
              type = str;
              description = "The OpenAI-compatible API endpoint that `pay-respects` will query for command corrections.";
            };
            model = mkOption {
              default = "";
              example = "llama3";
              type = str;
              description = "The model used by `pay-respects` to generate command corrections.";
            };
            locale = mkOption {
              default = toLower (replaceChars [ "_" ] [ "-" ] (substring 0 5 config.i18n.defaultLocale));
              example = "nl-be";
              type = str;
              description = ''
                The locale to be used for LLM responses.
                The accepted format is a lowercase [`ISO 639-1` language code](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes), followed by a dash '-', followed by a lowercase [`ISO 3166-1 alpha-2` country code](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2).
              '';
            };
          };
        });
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      map
        (attr: {
          assertion = (!isBool cfg.aiIntegration) -> (cfg.aiIntegration.${attr} != "");
          message = ''
            programs.pay-respects.aiIntegration is configured as a submodule, but you have not configured a value for programs.pay-respects.aiIntegration.${attr}!
          '';
        })
        [
          "url"
          "model"
        ];

    environment = {
      etc = listToAttrs (
        map (rule: {
          name = "xdg/pay-respects/rules/${rule.command}.toml";
          value = {
            source = generate "${rule.command}.toml" rule;
          };
        }) cfg.runtimeRules
      );

      systemPackages = [ finalPackage ];
    };

    programs = {
      bash.interactiveShellInit = initScript "bash";
      fish.interactiveShellInit = optionalString config.programs.fish.enable (initScript "fish");
      zsh.interactiveShellInit = optionalString config.programs.zsh.enable (initScript "zsh");
    };
  };
  meta.maintainers = with maintainers; [ sigmasquadron ];
}

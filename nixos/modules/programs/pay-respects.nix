{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    literalExpression
    maintainers
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optionalString
    types
    ;
  inherit (types) listOf str;

  cfg = config.programs.pay-respects;

  settingsFormat = pkgs.formats.toml { };
  inherit (settingsFormat) generate type;

  initScript =
    shell:
    if (shell != "fish") then
      ''
        eval $(${getExe pkgs.pay-respects} ${shell} --alias ${cfg.alias})
      ''
    else
      ''
        ${getExe pkgs.pay-respects} ${shell} --alias ${cfg.alias} | source
      '';
in
{
  options = {
    programs.pay-respects = {
      enable = mkEnableOption "pay-respects, an app which corrects your previous console command";

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
    };
  };

  config = mkIf cfg.enable {
    environment = mkMerge (
      [
        {
          systemPackages = [ pkgs.pay-respects ];
        }
      ]
      ++ map (rule: {
        etc."xdg/pay-respects/rules/${rule.command}.toml".source = generate "${rule.command}.toml" rule;
      }) cfg.runtimeRules
    );

    programs = {
      bash.interactiveShellInit = initScript "bash";
      fish.interactiveShellInit = optionalString config.programs.fish.enable (initScript "fish");
      zsh.interactiveShellInit = optionalString config.programs.zsh.enable (initScript "zsh");
    };
  };
  meta.maintainers = with maintainers; [ sigmasquadron ];
}

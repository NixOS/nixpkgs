{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    getExe
    maintainers
    mkEnableOption
    mkIf
    mkOption
    optionalString
    types
    ;
  inherit (types) str;
  cfg = config.programs.pay-respects;

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
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pay-respects ];

    programs = {
      bash.interactiveShellInit = initScript "bash";
      fish.interactiveShellInit = optionalString config.programs.fish.enable (initScript "fish");
      zsh.interactiveShellInit = optionalString config.programs.zsh.enable (initScript "zsh");
    };
  };
  meta.maintainers = with maintainers; [ sigmasquadron ];
}

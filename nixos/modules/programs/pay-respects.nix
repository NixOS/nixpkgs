{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.pay-respects;

  initScript =
    shell:
    if (shell != "fish") then
      ''
        eval $(${lib.getExe pkgs.pay-respects} ${shell} --alias ${cfg.alias})
      ''
    else
      ''
        ${lib.getExe pkgs.pay-respects} ${shell} --alias ${cfg.alias} | source
      '';
in
{
  options = {
    programs.pay-respects = {
      enable = lib.mkEnableOption "pay-respects, an app which corrects your previous console command";

      alias = lib.mkOption {
        default = "f";
        type = lib.types.str;
        description = ''
          `pay-respects` needs an alias to be configured.
          The default value is `f`, but you can use anything else as well.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pay-respects ];

    programs = {
      bash.interactiveShellInit = initScript "bash";
      fish.interactiveShellInit = lib.optionalString config.programs.fish.enable (initScript "fish");
      zsh.interactiveShellInit = lib.optionalString config.programs.zsh.enable (initScript "zsh");
    };
  };
  meta.maintainers = with lib.maintainers; [ sigmasquadron ];
}

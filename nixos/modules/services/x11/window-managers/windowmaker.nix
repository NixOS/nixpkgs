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
    literalExpression
    mkIf
    singleton
    ;
  inherit (lib.types) functionTo listOf package;
  cfg = config.services.xserver.windowManager.windowmaker;
in
{
  options = {
    services.xserver.windowManager.windowmaker = {
      enable = mkEnableOption "windowmaker";
      package = mkPackageOption pkgs "windowmaker" { };
      dockapps = mkOption {
        type = functionTo (listOf package);
        default = _: [ ];
        defaultText = literalExpression ''
          windowmaker: with windowmaker.dockapps; [ ];
        '';
        description = ''
          Extra dockapps available to WindowMaker.
        '';
        example = literalExpression ''
          windowmaker: with windowmaker.dockapps; [
            cputnik
            wmcube
          ];
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ] ++ cfg.dockapps cfg.package;
    services.xserver.windowManager.session = singleton {
      name = "windowmaker";
      start = ''
        ${lib.getExe cfg.package} &
        waitPID=$!
      '';
    };
  };
}

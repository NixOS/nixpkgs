{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.jolt;
in
{
  options.programs.jolt = {
    enable = lib.mkEnableOption "Jolt, a Clojure implementation on Chez Scheme";

    package = lib.mkPackageOption pkgs "jolt" { };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Additional packages to include alongside Jolt in the system environment.
      '';
    };

    chezPackage = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      example = lib.literalExpression "pkgs.chez";
      description = ''
        Optional custom Chez Scheme package to set in {env}`JOLT_CHEZ`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ] ++ cfg.extraPackages;

    environment.variables = lib.mkIf (cfg.chezPackage != null) {
      JOLT_CHEZ = lib.getExe' cfg.chezPackage "scheme";
    };
  };

  meta.maintainers = with lib.maintainers; [
    crimeminister
    yogthos
  ];
}

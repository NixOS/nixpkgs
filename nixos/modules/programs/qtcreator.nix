{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.qtcreator;
in
{
  options.programs.qtcreator = {
    enable = lib.mkEnableOption "Qt Creator IDE";

    defaultEditor = lib.mkEnableOption "" // {
      description = ''
        When enabled, configures Qt Creator to be the default editor
        using the EDITOR environment variable.
      '';
    };

    package = lib.mkPackageOption pkgs "qtcreator" {
      extraDescription = "The final package will be customized with plug-ins from {option}`programs.qtcreator.plugins`";
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression ''
        with pkgs.qt6Packages; [ qode-assist ]
      '';
      description = "List of plug-ins to install.";
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized Qt Creator package.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.finalPackage
    ];

    environment.variables.EDITOR = lib.mkIf cfg.defaultEditor (
      lib.mkOverride 900 cfg.finalPackage.meta.mainProgram
    );

    programs.qtcreator.finalPackage =
      let
        # Specifing path for each plugin cause Qt Creator will not search for them even if we create combined package with symlinks (hardcoded default search path)
        result = builtins.foldl' (
          acc: val: acc + "-pluginpath ${val.outPath}/lib/qtcreator/plugins/"
        ) "" cfg.plugins;
        qtcreator_runner = pkgs.writeShellScriptBin "qtcreator" ''
          exec ${cfg.package}/bin/qtcreator ${result} "$@"
        '';
      in
      pkgs.symlinkJoin {
        inherit (cfg.package) name version meta;
        paths = [
          qtcreator_runner
          cfg.package
        ];
      };
  };

  meta.maintainers = with lib.maintainers; [ zatm8 ];
}

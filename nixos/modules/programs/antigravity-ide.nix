{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.antigravity-ide;
in
{
  options.programs.antigravity-ide = {
    enable = lib.mkEnableOption "Antigravity IDE";

    defaultEditor = lib.mkEnableOption "" // {
      description = ''
        When enabled, configures Antigravity IDE to be the default editor using the EDITOR environment variable.
      '';
    };

    package = lib.mkPackageOption pkgs "antigravity-ide" {
      extraDescription = "The final package will be customized with extensions from {option}`programs.antigravity-ide.extensions`";
    };

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression ''
        with pkgs.vscode-extensions; [
          bbenoist.nix
          golang.go
        ]
      '';
      description = "List of extensions to install.";
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized Antigravity IDE package.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.finalPackage
    ];

    environment.sessionVariables.EDITOR = lib.mkIf cfg.defaultEditor (
      lib.mkOverride 900 cfg.finalPackage.meta.mainProgram
    );

    programs.antigravity-ide.finalPackage = pkgs.vscode-with-extensions.override {
      vscode = cfg.package;
      vscodeExtensions = cfg.extensions;
    };
  };

  meta.maintainers = with lib.maintainers; [ milas ];
}

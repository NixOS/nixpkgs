{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.vscode;
  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.vscode = {
    enable = lib.mkEnableOption "VSCode editor";

    defaultEditor = lib.mkEnableOption "" // {
      description = ''
        When enabled, configures VSCode to be the default editor
        using the EDITOR environment variable.
      '';
    };

    package = lib.mkPackageOption pkgs "vscode" {
      extraDescription = "The final package will be customized with extensions from {option}`programs.vscode.extensions`";
    };

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression ''
        with pkgs.vscode-extensions; [
          bbenoist.nix
          golang.go
          twxs.cmake
        ]
      '';
      description = "List of extensions to install.";
    };

    enterprisePolicies = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          "UpdateMode" = "none";
          "TelemetryLevel" = "off";
        }
      '';
      description = ''
        System-wide policies for VSCode in `/etc/vscode/policy.json`.
        See <https://code.visualstudio.com/docs/setup/enterprise#_centrally-manage-vs-code-settings> for more information.
      '';
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized VSCode package.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.finalPackage
      ];

      sessionVariables.EDITOR = lib.mkIf cfg.defaultEditor (
        lib.mkOverride 900 cfg.finalPackage.meta.mainProgram
      );

      etc."vscode/policy.json" = lib.mkIf (cfg.enterprisePolicies != { }) {
        source = jsonFormat.generate "vscode-policy.json" cfg.enterprisePolicies;
      };
    };

    programs.vscode.finalPackage = pkgs.vscode-with-extensions.override {
      vscode = cfg.package;
      vscodeExtensions = cfg.extensions;
    };
  };

  meta.maintainers = with lib.maintainers; [ ethancedwards8 ];
}

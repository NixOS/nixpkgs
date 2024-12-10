# Options that can be used for creating a jupyter kernel.
{ lib, pkgs }:

with lib;

{
  freeformType = (pkgs.formats.json { }).type;

  options = {

    displayName = mkOption {
      type = types.str;
      default = "";
      example = literalExpression ''
        "Python 3"
        "Python 3 for Data Science"
      '';
      description = ''
        Name that will be shown to the user.
      '';
    };

    argv = mkOption {
      type = types.listOf types.str;
      example = [
        "{customEnv.interpreter}"
        "-m"
        "ipykernel_launcher"
        "-f"
        "{connection_file}"
      ];
      description = ''
        Command and arguments to start the kernel.
      '';
    };

    language = mkOption {
      type = types.str;
      example = "python";
      description = ''
        Language of the environment. Typically the name of the binary.
      '';
    };

    env = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        OMP_NUM_THREADS = "1";
      };
      description = ''
        Environment variables to set for the kernel.
      '';
    };

    logo32 = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = literalExpression ''"''${env.sitePackages}/ipykernel/resources/logo-32x32.png"'';
      description = ''
        Path to 32x32 logo png.
      '';
    };
    logo64 = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = literalExpression ''"''${env.sitePackages}/ipykernel/resources/logo-64x64.png"'';
      description = ''
        Path to 64x64 logo png.
      '';
    };

    extraPaths = mkOption {
      type = types.attrsOf types.path;
      default = { };
      example = literalExpression ''"{ examples = ''${env.sitePack}/IRkernel/kernelspec/kernel.js"; }'';
      description = ''
        Extra paths to link in kernel directory
      '';
    };
  };
}

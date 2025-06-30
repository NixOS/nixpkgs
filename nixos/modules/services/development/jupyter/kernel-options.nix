# Options that can be used for creating a jupyter kernel.
{ lib, pkgs }:
{
  freeformType = (pkgs.formats.json { }).type;

  options = {

    displayName = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = lib.literalExpression ''
        "Python 3"
        "Python 3 for Data Science"
      '';
      description = ''
        Name that will be shown to the user.
      '';
    };

    argv = lib.mkOption {
      type = lib.types.listOf lib.types.str;
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

    language = lib.mkOption {
      type = lib.types.str;
      example = "python";
      description = ''
        Language of the environment. Typically the name of the binary.
      '';
    };

    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        OMP_NUM_THREADS = "1";
      };
      description = ''
        Environment variables to set for the kernel.
      '';
    };

    logo32 = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''"''${env.sitePackages}/ipykernel/resources/logo-32x32.png"'';
      description = ''
        Path to 32x32 logo png.
      '';
    };
    logo64 = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''"''${env.sitePackages}/ipykernel/resources/logo-64x64.png"'';
      description = ''
        Path to 64x64 logo png.
      '';
    };

    extraPaths = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = lib.literalExpression ''"{ examples = ''${env.sitePack}/IRkernel/kernelspec/kernel.js"; }'';
      description = ''
        Extra paths to link in kernel directory
      '';
    };
  };
}

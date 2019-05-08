# Options that can be used for creating a jupyter kernel.
{lib }:

with lib;

{
  options = {

    displayName = mkOption {
      type = types.str;
      default = "";
      example = [
        "Python 3"
        "Python 3 for Data Science"
      ];
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

    jsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "{env.sitePackages}/ipykernel/resources/kernel.js";
      description = ''
        Path to the kernel's front end javascript file.
      '';
    };

    logo32 = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "{env.sitePackages}/ipykernel/resources/logo-32x32.png";
      description = ''
        Path to 32x32 logo png.
      '';
    };
    logo64 = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "{env.sitePackages}/ipykernel/resources/logo-64x64.png";
      description = ''
        Path to 64x64 logo png.
      '';
    };
  };
}

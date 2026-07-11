{
  lib,
  pkgs,
  mkEnableOption,
  mkOption,
  mkExtraConfigOption,
  ...
}:
{
  type = lib.types.submodule {
    options = {
      enable = mkEnableOption "Kali text to speech output module";

      # TODO use mkPackageOption if Kali is packaged
      package = mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.kali or null;
        defaultText = "pkgs.kali";
        description = ''
          The Kali text-to-spech package to use.

          Since `kali` is not yet in nixpkgs, you must override this
          with your own derivation (or a package from an overlay) if you
          want to enable the module.
        '';
        example = "pkgs.kali";
      };

      debug = mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable debug output.
        '';
        example = true;
      };

      extraConfig = mkExtraConfigOption { };
    };
  };

  # TODO remove if Kali is packaged in Nixpkgs.
  visible = false;
  displayName = "Kali";
  binary = "sd_kali";
  confFile = "kali.conf";
}

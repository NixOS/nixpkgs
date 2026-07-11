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
      enable = mkEnableOption "Llia Phon text to speech output module";

      # TODO use mkPackageOption if Llia Phon gets packaged
      package = mkOption {
        type = lib.types.nullOr lib.types.package;
        default = pkgs.llia-phon or null;
        defaultText = "pkgs.llia-phon";
        description = ''
          The Llia Phon text-to-spech package to use.

          Since `llia-phon` is not yet in nixpkgs, you must override this
          with your own derivation (or a package from an overlay) if you
          want to enable the module.
        '';
        example = "pkgs.llia-phon";
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

  # TODO remove if Llia Phon is packaged in Nixpkgs.
  visible = false;
  displayName = "Llia Phon";
  confFile = "llia_phon-generic.conf";
}

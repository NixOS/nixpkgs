{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.programs.espanso-capdacoverride;
in
{
  meta = {
    maintainers = with lib.maintainers; [ pitkling ];
  };

  options = {
    programs.espanso-capdacoverride = {
      enable = mkEnableOption "Espanso with CAP_DAC_OVERRIDE capability";

      package = lib.mkPackageOption pkgs "espanso" { example = "espanso-wayland"; };

      packageOverriden = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description = ''
          This option provides access to the overridden result of `programs.espanso-capdacoverride.package`.

          For example, the following configuration makes all the Nixpkgs packages use the overridden `espanso`:
          ```Nix
          { config, lib, pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
               _espanso-orig = prev.espanso;
               espanso = config.programs.espanso-capdacoverride.packageOverriden;
               })
            ];

            programs.espanso-capdacoverride = {
              enable = true;
              package = pkgs._espanso-orig;
            }
          }
          ```
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    programs.espanso-capdacoverride.packageOverriden = (
      pkgs.callPackage ./espanso-capdacoverride.nix {
        capDacOverrideWrapperDir = "${config.security.wrapperDir}";
        espanso = cfg.package;
      }
    );

    environment.systemPackages = [ cfg.packageOverriden ];

    security.wrappers."${cfg.packageOverriden.meta.mainProgram}-capdacoverride" = {
      source = "${lib.getExe cfg.packageOverriden}";
      capabilities = "cap_dac_override+p";
      owner = "root";
      group = "root";
    };
  };
}

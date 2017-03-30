{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.fonts.fontconfig.penultimate;

  latestVersion  = pkgs.fontconfig.configVersion;

  # The configuration to be included in /etc/font/
  confPkg = pkgs.runCommand "font-penultimate-conf" {} ''
    support_folder=$out/etc/fonts/conf.d
    latest_folder=$out/etc/fonts/${latestVersion}/conf.d

    mkdir -p $support_folder
    mkdir -p $latest_folder

    # fontconfig ultimate various configuration files
    ln -s ${pkgs.fontconfig-penultimate}/etc/fonts/conf.d/*.conf \
          $support_folder
    ln -s ${pkgs.fontconfig-penultimate}/etc/fonts/conf.d/*.conf \
          $latest_folder
  '';

in
{

  options = {

    fonts = {

      fontconfig = {

        penultimate = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable fontconfig-penultimate settings to supplement the
              NixOS defaults by providing per-font rendering defaults and
              metric aliases.
            '';
          };
        };

      };
    };

  };

  config = mkIf (config.fonts.fontconfig.enable && cfg.enable) {

    fonts.fontconfig.confPackages = [ confPkg ];

  };

}

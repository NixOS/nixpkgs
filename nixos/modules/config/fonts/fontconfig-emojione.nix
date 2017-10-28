{ config, pkgs, lib, ... }:

with lib;

let fcBool = x: if x then "<bool>true</bool>" else "<bool>false</bool>";

    cfg = config.fonts.fontconfig.emojione;

    latestVersion  = pkgs.fontconfig.configVersion;

    # The configuration to be included in /etc/font/
    confPkg = pkgs.runCommand "font-emojione-conf" {} ''
      support_folder=$out/etc/fonts/conf.d
      latest_folder=$out/etc/fonts/${latestVersion}/conf.d

      mkdir -p $support_folder
      mkdir -p $latest_folder


      # fontconfig emojione configuration file
      ln -s ${pkgs.emojione}/etc/fonts/conf.d/56-emojione-color.conf \
            $support_folder
      ln -s ${pkgs.emojione}/etc/fonts/conf.d/56-emojione-color.conf \
            $latest_folder
    '';

in
{

  options = {

    fonts = {

      fontconfig = {

        emojione = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable emojione settings.
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

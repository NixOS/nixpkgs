{ config, pkgs, lib, ... }:

with lib;

let cfg = config.fonts.fontconfig.ultimate;

    latestVersion  = pkgs.fontconfig.configVersion;

    # The configuration to be included in /etc/font/
    confPkg = pkgs.runCommand "font-ultimate-conf" { preferLocalBuild = true; } ''
      support_folder=$out/etc/fonts/conf.d
      latest_folder=$out/etc/fonts/${latestVersion}/conf.d

      mkdir -p $support_folder
      mkdir -p $latest_folder

      # fontconfig ultimate substitutions
      ${optionalString (cfg.substitutions != "none") ''
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/presets/${cfg.substitutions}/*.conf \
            $support_folder
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/presets/${cfg.substitutions}/*.conf \
            $latest_folder
      ''}

      # fontconfig ultimate various configuration files
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/conf.d/*.conf \
            $support_folder
      ln -s ${pkgs.fontconfig-ultimate}/etc/fonts/conf.d/*.conf \
            $latest_folder
    '';

in
{

  options = {

    fonts = {

      fontconfig = {

        ultimate = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable fontconfig-ultimate settings (formerly known as
              Infinality). Besides the customizable settings in this NixOS
              module, fontconfig-ultimate also provides many font-specific
              rendering tweaks.
            '';
          };

          substitutions = mkOption {
            type = types.enum ["free" "combi" "ms" "none"];
            default = "free";
            description = ''
              Font substitutions to replace common Type 1 fonts with nicer
              TrueType fonts. <literal>free</literal> uses free fonts,
              <literal>ms</literal> uses Microsoft fonts,
              <literal>combi</literal> uses a combination, and
              <literal>none</literal> disables the substitutions.
            '';
          };

          preset = mkOption {
            type = types.enum ["ultimate1" "ultimate2" "ultimate3" "ultimate4" "ultimate5" "osx" "windowsxp"];
            default = "ultimate3";
            description = ''
              FreeType rendering settings preset. Any of the presets may be
              customized by setting environment variables.
            '';
          };
        };
      };
    };

  };

  config = mkIf (config.fonts.fontconfig.enable && cfg.enable) {

    fonts.fontconfig.confPackages = [ confPkg ];
    environment.variables."INFINALITY_FT" = cfg.preset;

  };

}

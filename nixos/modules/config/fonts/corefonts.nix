{ config, pkgs, ... }:

with pkgs.lib;

{

  options = {

    fonts = {

      enableCoreFonts = mkOption {
        default = false;
        description = ''
          Whether to include Microsoft's proprietary Core Fonts.  These fonts
          are redistributable, but only verbatim, among other restrictions.
          See <link xlink:href="http://corefonts.sourceforge.net/eula.htm"/>
          for details.
       '';
      };

    };

  };


  config = mkIf config.fonts.enableCoreFonts {

    fonts.extraFonts = [ pkgs.corefonts ];

  };

}

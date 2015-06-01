# This module is deprecated, since you can just say ‘fonts.fonts = [
# pkgs.corefonts ];’ instead.

{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    fonts = {

      enableCoreFonts = mkOption {
        visible = false;
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

    fonts.fonts = [ pkgs.corefonts ];

  };

}

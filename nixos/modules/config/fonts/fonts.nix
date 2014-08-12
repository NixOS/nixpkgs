{ config, lib, pkgs, ... }:

with lib;

{

  options = {

    fonts = {

      # TODO: find another name for it.
      fonts = mkOption {
        type = types.listOf types.path;
        example = [ pkgs.dejavu_fonts ];
        description = "List of primary font paths.";
        apply = list: list ++
          [ # - the user's current profile
            "~/.nix-profile/lib/X11/fonts"
            "~/.nix-profile/share/fonts"
            # - the default profile
            "/nix/var/nix/profiles/default/lib/X11/fonts"
            "/nix/var/nix/profiles/default/share/fonts"
          ];
      };

    };

  };

  config = {

    fonts.fonts =
      [ pkgs.xorg.fontbhttf
        pkgs.xorg.fontbhlucidatypewriter100dpi
        pkgs.xorg.fontbhlucidatypewriter75dpi
        pkgs.ttf_bitstream_vera
        pkgs.freefont_ttf
        pkgs.liberation_ttf
        pkgs.xorg.fontbh100dpi
        pkgs.xorg.fontmiscmisc
        pkgs.xorg.fontcursormisc
      ];

  };

}

{ lib, pkgs }:

lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    # ui can be: gtk2, gtk3, sixel, framebuffer. Note that console display (sixel)
    # requires a terminal that supports `sixel` capabilities, such as mlterm
    # or xterm -ti 340
    ui = "gtk3";
    uilib =
      {
        "framebuffer" = "framebuffer";
        "gtk2" = "gtk2";
        "gtk3" = "gtk3";
        "sixel" = "framebuffer";
      }
      .${self.ui} or null; # Null will never happen
    SDL =
      {
        "sixel" = pkgs.SDL_sixel;
        "framebuffer" = pkgs.SDL;
      }
      .${self.ui} or null;

    browser = callPackage ./browser.nix { };

    buildsystem = pkgs.netsurf-buildsystem;
    libcss = pkgs.libcss;
    libdom = pkgs.libdom;
    libhubbub = pkgs.libhubbub;
    libnsbmp = pkgs.libnsbmp;
    libnsfb = pkgs.libnsfb;
    libnsgif = pkgs.libnsgif;
    libnslog = pkgs.libnslog;
    libnspsl = callPackage ./libnspsl.nix { };
    libnsutils = callPackage ./libnsutils.nix { };
    libparserutils = pkgs.libparserutils;
    libsvgtiny = callPackage ./libsvgtiny.nix { };
    libutf8proc = callPackage ./libutf8proc.nix { };
    libwapcaplet = pkgs.libwapcaplet;
    nsgenbind = callPackage ./nsgenbind.nix { };
  }
)

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
    libnspsl = pkgs.libnspsl;
    libnsutils = pkgs.libnsutils;
    libparserutils = pkgs.libparserutils;
    libsvgtiny = pkgs.libsvgtiny;
    libutf8proc = pkgs.libutf8proc;
    libwapcaplet = pkgs.libwapcaplet;
    nsgenbind = callPackage ./nsgenbind.nix { };
  }
)

{ lib, pkgs }:

lib.makeScope pkgs.newScope (self:
  let
    inherit (self) callPackage;
  in {
  # ui can be: gtk2, gtk3, sixel, framebuffer. Note that console display (sixel)
  # requires a terminal that supports `sixel` capabilities, such as mlterm
  # or xterm -ti 340
  ui = "gtk3";
  uilib = {
    "framebuffer" = "framebuffer";
    "gtk2" = "gtk2";
    "gtk3" = "gtk3";
    "sixel" = "framebuffer";
  }.${self.ui} or null; # Null will never happen
  SDL = {
    "sixel" = pkgs.SDL_sixel;
    "framebuffer" = pkgs.SDL;
  }.${self.ui} or null;

  browser = callPackage ./browser.nix { };

  buildsystem    = callPackage ./buildsystem.nix { };
  libcss         = callPackage ./libcss.nix { };
  libdom         = callPackage ./libdom.nix { };
  libhubbub      = callPackage ./libhubbub.nix { };
  libnsbmp       = callPackage ./libnsbmp.nix { };
  libnsfb        = callPackage ./libnsfb.nix { };
  libnsgif       = callPackage ./libnsgif.nix { };
  libnslog       = callPackage ./libnslog.nix { };
  libnspsl       = callPackage ./libnspsl.nix { };
  libnsutils     = callPackage ./libnsutils.nix { };
  libparserutils = callPackage ./libparserutils.nix { };
  libsvgtiny     = callPackage ./libsvgtiny.nix { };
  libutf8proc    = callPackage ./libutf8proc.nix { };
  libwapcaplet   = callPackage ./libwapcaplet.nix { };
  nsgenbind      = callPackage ./nsgenbind.nix { };
})

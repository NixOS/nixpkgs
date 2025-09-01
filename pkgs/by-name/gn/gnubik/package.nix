{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  guile_2_0,
  gettext,
  gtk2-x11,
  libGL,
  libGLU,
  gtk2,
  gnome2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnubik";
  version = "2.4.3";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gnubik/gnubik-${finalAttrs.version}.tar.gz";
    hash = "sha256-Kz7Tb7W6nuyA/Yb5Tqu+hmUG9P4ZSKnXSA8iXIlIju4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    guile_2_0
    gettext
    gtk2-x11
  ];

  buildInputs = [
    libGL
    libGLU
    guile_2_0
    gtk2
    gnome2.gtkglext
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "3D Rubik's cube game";
    longDescription = ''
      The Gnubik program is an interactive, graphical, single player
      puzzle. Yes, this is another implementation of the classic game
      like that invented by Erno Rubik. You have to manipulate the
      cube using the mouse. When each face shows only one colour, the
      game is solved.

      Gnubik is written in C and Guile. The latter allows you to
      extend the program using the Scheme language — a simple
      programming tool which even novice computer users can use. For
      example, you can use Scheme to write your own automated solving
      routines or to create patterns.
    '';
    homepage = "https://www.gnu.org/software/gnubik";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gnubik";
    platforms = lib.platforms.all;
  };
})

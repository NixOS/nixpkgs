<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, fetchurl, cmake, qtbase, wrapQtAppsHook }:
stdenv.mkDerivation rec {
  version = "12.0";
  pname = "textadept";

=======
{ lib, stdenv, fetchFromGitHub, fetchurl, gtk2, glib, pkg-config, unzip, ncurses, zip }:

stdenv.mkDerivation rec {
  version = "11.4";
  pname = "textadept";

  nativeBuildInputs = [ pkg-config unzip zip ];
  buildInputs = [
    gtk2 ncurses glib
  ];

  enableParallelBuilding = true;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
    rev = "textadept_${version}";
<<<<<<< HEAD
    sha256 = "sha256-KziVN0Fl/IvSnIJKK5s7UikXi3iP5mTauP0YxffKy9c=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ qtbase ];

  cmakeFlags = [
    "CMAKE_INSTALL_PREFIX=build/install"
  ];

  preConfigure = ''
    mkdir -p $PWD/build/_deps

    '' +
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: params:
      "ln -s ${fetchurl params} $PWD/build/_deps/${name}"
    ) (import ./deps.nix));
=======
    sha256 = "sha256-1we2NC4N8oY4QmmqIIWGSpTBuLx3MEFkZK+BjmNEfD0=";
  };

  preConfigure =
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: params:
      "ln -s ${fetchurl params} $PWD/src/${name}"
    ) (import ./deps.nix)) + ''

    cd src
    make deps
  '';

  postBuild = ''
    make curses
  '';

  preInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/pixmaps
  '';

  postInstall = ''
    make curses install PREFIX=$out MAKECMDGOALS=curses
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "WGET=true"
    "PIXMAPS_DIR=$(out)/share/pixmaps"
    "GTK2=1"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "An extensible text editor based on Scintilla with Lua scripting.";
    homepage = "http://foicica.com/textadept";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon patricksjackson ];
    platforms = platforms.linux;
  };
}

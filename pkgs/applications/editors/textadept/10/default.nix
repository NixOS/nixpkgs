{ lib, stdenv, fetchhg, fetchurl, gtk2, glib, pkg-config, unzip, ncurses, zip }:

stdenv.mkDerivation rec {
  version = "10.8";
  pname = "textadept";

  nativeBuildInputs = [ pkg-config unzip ];
  buildInputs = [
    gtk2 ncurses glib zip
  ];

  src = fetchhg {
    url = "http://foicica.com/hg/textadept";
    rev = "textadept_${version}";
    sha256 = "sha256-dEZSx2tuHTWYhk9q5iGlrWTAvDvKaM8HaHwXcFcv33s=";
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
    "PREFIX=$(out) WGET=true PIXMAPS_DIR=$(out)/share/pixmaps"
  ];

  meta = with lib; {
    description = "An extensible text editor based on Scintilla with Lua scripting";
    homepage = "http://foicica.com/textadept";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon ];
    platforms = platforms.linux;
  };
}

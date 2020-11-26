{ lib, stdenv, fetchhg, fetchFromGitHub, fetchurl, gtk2, glib, pkgconfig, unzip, ncurses, zip }:

stdenv.mkDerivation rec {
  version = "11.0_beta";
  pname = "textadept11";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk2 ncurses glib unzip zip
  ];

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
    rev = "8da5f6b4a13f14b9dd3cb9dc23ad4f7bf41e91c1";
    sha256 = "0v11v3x8g6v696m3l1bm52zy2g9xzz7hlmn912sn30nhcag3raxs";
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

  meta = with stdenv.lib; {
    description = "An extensible text editor based on Scintilla with Lua scripting. Version 11_beta";
    homepage = "http://foicica.com/textadept";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon ];
    platforms = platforms.linux;
  };
}

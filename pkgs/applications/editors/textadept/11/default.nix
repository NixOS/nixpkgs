{ lib, stdenv, fetchFromGitHub, fetchurl, gtk2, glib, pkg-config, unzip, ncurses, zip }:

stdenv.mkDerivation rec {
  version = "11.1";
  pname = "textadept11";

  nativeBuildInputs = [ pkg-config unzip zip ];
  buildInputs = [
    gtk2 ncurses glib
  ];

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
    rev = "1df99d561dd2055a01efa9183bb9e1b2ad43babc";
    sha256 = "0g4bh5dp391vi32aa796vszpbxyl2dm5231v9dwc8l9v0b2786qn";
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
  ];

  meta = with lib; {
    description = "An extensible text editor based on Scintilla with Lua scripting. Version 11_beta";
    homepage = "http://foicica.com/textadept";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon ];
    platforms = platforms.linux;
  };
}

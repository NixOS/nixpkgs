{ lib, stdenv, fetchFromGitHub, fetchurl, gtk2, glib, pkg-config, unzip, ncurses, zip }:

stdenv.mkDerivation rec {
  version = "11.3";
  pname = "textadept11";

  nativeBuildInputs = [ pkg-config unzip zip ];
  buildInputs = [
    gtk2 ncurses glib
  ];

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
    rev = "textadept_${version}";
    sha256 = "sha256-C7J/Qr/58hLbyw39R+GU4wot1gbAXf51Cv6KGk3kg30=";
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
    description = "An extensible text editor based on Scintilla with Lua scripting.";
    homepage = "http://foicica.com/textadept";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon ];
    platforms = platforms.linux;
  };
}

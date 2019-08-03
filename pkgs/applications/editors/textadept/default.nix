{ lib, stdenv, fetchhg, fetchurl, gtk2, glib, pkgconfig, unzip, ncurses, zip }:
stdenv.mkDerivation rec {
  version = "10.2";
  name = "textadept-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk2 ncurses glib unzip zip
  ];

  src = fetchhg {
    url = http://foicica.com/hg/textadept;
    rev = "textadept_${version}";
    sha256 = "0fai8xqddkkprmbf0cf8wwgv7ccfdb1iyim30nppm2m16whkc8fl";
  };

  preConfigure =
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: params:
      "ln -s ${fetchurl params} $PWD/src/${name}"
    ) (import ./deps.nix)) + ''

    # work around trying to download stuff in `make deps`
    function wget() { true; }
    export -f wget

    cd src
    make deps
  '';

  postBuild = ''
    make curses
  '';

  postInstall = ''
    make curses install PREFIX=$out MAKECMDGOALS=curses
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "An extensible text editor based on Scintilla with Lua scripting";
    homepage = http://foicica.com/textadept;
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon ];
    platforms = platforms.linux;
  };
}

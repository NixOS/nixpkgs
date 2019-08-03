{ stdenv, fetchFromGitHub, autoreconfHook, autoconf, automake, pkgconfig, glib
, perl, ncurses, hamlib, xmlrpc_c }:

stdenv.mkDerivation rec {
  pname = "tlf";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0gniysjm8aq5anq0a0az31vd6h1vyg56bifc7rpf53lsh9hkzmgc";
  };

  nativeBuildInputs = [ autoreconfHook autoconf automake pkgconfig perl ];
  buildInputs = [ glib ncurses hamlib xmlrpc_c ];

  configureFlags = [ "--enable-hamlib" "--enable-fldigi-xmlrpc" ];

  postInstall = ''
    mkdir -p $out/lib

    # Hack around lack of libtinfo in NixOS
    ln -s ${ncurses.out}/lib/libncursesw.so.6 $out/lib/libtinfo.so.5
  '';

  meta = with stdenv.lib; {
    description = "Advanced ham radio logging and contest program";
    longDescription = ''
      TLF is a curses based console mode general logging and contest program for
      amateur radio.

      It supports the CQWW, the WPX, the ARRL-DX, the ARRL-FD, the PACC and the
      EU SPRINT shortwave contests (single operator) as well as a LOT MORE basic
      contests, general QSO and DXpedition mode.
    '';
    homepage = https://tlf.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, autoreconfHook, autoconf, automake, pkgconfig, glib
, perl, ncurses5, hamlib, xmlrpc_c }:

stdenv.mkDerivation rec {
  pname = "tlf";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "0f97hxiwc6blp5haik871q6zzvwy0b3p2jg8ad2dvaxg07xc76l0";
  };

  nativeBuildInputs = [ autoreconfHook autoconf automake pkgconfig perl ];
  buildInputs = [ glib ncurses5 hamlib xmlrpc_c ];

  configureFlags = [ "--enable-hamlib" "--enable-fldigi-xmlrpc" ];

  postInstall = ''
    mkdir -p $out/lib
    ln -s ${ncurses5.out}/lib/libtinfo.so.5 $out/lib/libtinfo.so.5
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

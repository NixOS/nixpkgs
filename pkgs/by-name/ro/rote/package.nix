{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "rote";
  version = "0.2.8";

  src = fetchurl {
    sha256 = "05v1lw99jv4cwxl7spyi7by61j2scpdsvx809x5cga7dm5dhlmky";
    url = "mirror://sourceforge/rote/${pname}-${version}.tar.gz";
  };

  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Our Own Terminal Emulation Library";
    mainProgram = "rote-config";
    longDescription = ''
      ROTE is a simple C library for VT102 terminal emulation. It allows the
      programmer to set up virtual 'screens' and send them data. The virtual
      screens will emulate the behavior of a VT102 terminal, interpreting
      escape sequences, control characters and such. The library supports
      ncurses as well so that you may render the virtual screen to the real
      screen when you need to.
    '';
    homepage = "https://rote.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}

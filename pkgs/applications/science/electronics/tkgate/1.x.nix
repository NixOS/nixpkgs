{ stdenv, fetchurl, tcl, tk, libX11, glibc, which, yacc, flex, imake, xproto, gccmakedep }:

let
  libiconvInc = stdenv.lib.optionalString stdenv.isLinux "${glibc}/include";
  libiconvLib = stdenv.lib.optionalString stdenv.isLinux "${glibc}/lib";
in
stdenv.mkDerivation rec {
  name = "tkgate-1.8.7";

  src = fetchurl {
    url = "http://www.tkgate.org/downloads/${name}.tgz";
    sha256 = "1pqywkidfpdbj18i03h97f4cimld4fb3mqfy8jjsxs12kihm18fs";
  };

  buildInputs = [ tcl tk libX11 which yacc flex imake xproto gccmakedep ];

  patchPhase = ''
    sed -i config.h \
      -e 's|.*#define.*TKGATE_TCLTK_VERSIONS.*|#define TKGATE_TCLTK_VERSIONS "8.5"|' \
      -e 's|.*#define.*TKGATE_INCDIRS.*|#define TKGATE_INCDIRS "${tcl}/include ${tk}/include ${libiconvInc} ${libX11}/include"|' \
      -e 's|.*#define.*TKGATE_LIBDIRS.*|#define TKGATE_LIBDIRS "${tcl}/lib ${tk}/lib ${libiconvLib} ${libX11}/lib"|' \
      \
      -e '20 i #define TCL_LIBRARY "${tcl}/lib"' \
      -e '20 i #define TK_LIBRARY "${tk}/lib/${tk.libPrefix}"' \
      -e '20 i #define USE_ICONV 1' \
      \
      -e "s|.*#define.*TKGATE_HOMEDIRBASE.*|#define TKGATE_HOMEDIRBASE \\\"$out/lib\\\"|" \
      -e "s|.*#define.*TKGATE_BINDIR.*|#define TKGATE_BINDIR \\\"$out/bin\\\"|" \
      -e "s|.*#define.*TKGATE_MANDIR.*|#define TKGATE_MANDIR \\\"$out/share/man/man1\\\"|" \
      -e "s|file:/usr/X11R6/lib/tkgate-|file://$out/lib/tkgate-|"
  '';

  meta = {
    description = "Event driven digital circuit simulator with a TCL/TK-based graphical editor";
    homepage = "http://www.tkgate.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.simons ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}

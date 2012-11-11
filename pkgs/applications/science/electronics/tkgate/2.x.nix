{ stdenv, fetchurl, tcl, tk, libX11, libiconvOrLibc }:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name = "tkgate-2.0-b10";

  src = fetchurl {
    url = "http://www.tkgate.org/downloads/${name}.tgz";
    sha256 = "0mr061xcwjmd8nhyjjcw2dzxqi53hv9xym9xsp0cw98knz2skxjf";
  };

  buildInputs = [ tcl tk libX11 ];

  dontStrip = true;

  patchPhase = ''
    sed -i configure \
      -e 's|TKGATE_INCDIRS=.*|TKGATE_INCDIRS="${tcl}/include ${tk}/include ${libiconvOrLibc}/include"|' \
      -e 's|TKGATE_LIBDIRS=.*|TKGATE_LIBDIRS="${tcl}/lib ${tk}/lib ${libiconvOrLibc}/lib"|'
    sed -i options.h \
      -e 's|.* #define TCL_LIBRARY .*|#define TCL_LIBRARY "${tcl}/${tcl.libdir}"|' \
      -e 's|.* #define TK_LIBRARY .*|#define TK_LIBRARY "${tk}/lib/${tk.libPrefix}"|'
  '';

  meta = {
    description = "Event driven digital circuit simulator with a TCL/TK-based graphical editor";
    homepage = "http://www.tkgate.org/";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}

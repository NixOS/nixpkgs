{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  hoppet,
  lhapdf,
  root,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "applgrid";
  version = "1.6.27";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/applgrid/${pname}-${version}.tgz";
    hash = "sha256-h+ZNGj33FIwg4fOCyfGJrUKM2vDDQl76JcLhtboAOtc=";
  };

  postPatch = ''
    sed -i appl_grid/serialise_base.h -e '1i#include <cstdint>'
  '';

  nativeBuildInputs = [ gfortran ];

  # For some reason zlib was only needed after bump to gfortran8
  buildInputs = [
    hoppet
    lhapdf
    root
    zlib
  ];

  preConfigure = ''
    substituteInPlace src/Makefile.in \
      --replace-fail "-L\$(subst /libgfortran.a, ,\$(FRTLIB) )" "-L${gfortran.cc.lib}/lib"
  ''
  + (lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/Makefile.in \
      --replace-fail "gfortran -print-file-name=libgfortran.a" "gfortran -print-file-name=libgfortran.dylib" \
      --replace-fail 'libfAPPLgrid_la_LIBADD =' 'libfAPPLgrid_la_LIBADD = $(FRTLLIB)' \
      --replace-fail '$(CXXLINK) -rpath $(libdir) $(libfAPPLgrid_la_OBJECTS) $(libfAPPLgrid_la_LIBADD) $(LIBS)' \
                     '$(CXXLINK) -rpath $(libdir) $(libfAPPLgrid_la_OBJECTS) $(libfAPPLgrid_la_LIBADD) $(LIBS) -Wl,-undefined,dynamic_lookup'
  '');

  enableParallelBuilding = false; # broken

  # Install private headers required by APFELgrid
  postInstall = ''
    for header in src/*.h; do
      install -Dm644 "$header" "$out"/include/appl_grid/"`basename $header`"
    done
  '';

  meta = with lib; {
    description = "Fast and flexible way to reproduce the results of full NLO calculations with any input parton distribution set in only a few milliseconds rather than the weeks normally required to gain adequate statistics";
    license = licenses.gpl3;
    homepage = "http://applgrid.hepforge.org";
    platforms = platforms.unix;
    maintainers = with maintainers; [ veprbl ];
  };
}

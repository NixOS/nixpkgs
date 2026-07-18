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

stdenv.mkDerivation (finalAttrs: {
  pname = "applgrid";
  version = "1.6.27";

  src = fetchurl {
    url = "https://www.hepforge.org/archive/applgrid/applgrid-${finalAttrs.version}.tgz";
    hash = "sha256-h+ZNGj33FIwg4fOCyfGJrUKM2vDDQl76JcLhtboAOtc=";
  };

  patches = [
    # Upstream's configure unconditionally injects `-m64` into CXXFLAGS, which is
    # invalid on aarch64 (and redundant on x86_64). The line was added in r1946
    # for applgrid 1.6.17 with the commit message "add default m64 compilation".
    # There is no public bug tracker upstream, and the line is still present in
    # trunk. We patch only the generated `configure` (not `configure.ac`) so
    # that make doesn't try to re-run autotools during the build.
    ./no-m64.patch

    # ROOT 6.40 made rootcling fail when no selection rules are provided
    # (https://root.cern/doc/v640/release-notes.html#core-libraries). The patch
    # appends $*LinkDef.h to the dictionary pattern rule so rootcint picks up
    # the LinkDef.h files we drop into src/ in postPatch.
    ./rootcling-linkdef.patch
  ];

  postPatch = ''
    cp ${./TFileStringLinkDef.h} src/TFileStringLinkDef.h
    cp ${./TFileVectorLinkDef.h} src/TFileVectorLinkDef.h

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

  meta = {
    description = "Fast and flexible way to reproduce the results of full NLO calculations with any input parton distribution set in only a few milliseconds rather than the weeks normally required to gain adequate statistics";
    license = lib.licenses.gpl3;
    homepage = "http://applgrid.hepforge.org";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})

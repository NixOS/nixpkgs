{stdenv, fetchurl, panotools, cmake, wxGTK, libtiff, libpng, openexr, boost,
  pkgconfig, exiv2, gettext, ilmbase, enblendenfuse, autopanosiftc }:

stdenv.mkDerivation {
  name = "hugin-0.7.0";

  src = fetchurl {
    url = mirror://sourceforge/hugin/hugin-0.7.0.tar.gz;
    sha256 = "0nbrvzz94gqgk2v1900lly101g0wjz4zksnh5718226n2g8zlccf";
  };

  patches = [ ./levmar-64-bit-alignment.patch ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  NIX_LDFLAGS = "-lrt";

  # I added these flags to get all the rpaths right, which I guess they are
  # taken from the qt4 sources. Not very nice.
  cmakeFlags = "-DCMAKE_SHARED_LINKER_FLAGS=\"-Wl,-rpath,$out/lib\"" +
    " -DCMAKE_EXE_LINKER_FLAGS=\"-Wl,-rpath,$out/lib" +
    " -lpng12 -lpano13 -lImath -lIlmImf -lIex -lHalf -lIlmThread" +
    " -ljpeg -ltiff -lz -lexiv2 -lboost_thread\"" +
    " -DCMAKE_SKIP_BUILD_RPATH=ON" +
    " -DCMAKE_BUILD_TYPE=Release" +
    " -DCMAKE_INSTALL_PREFIX=$out";

  buildInputs = [ cmake panotools wxGTK libtiff libpng openexr boost pkgconfig exiv2 gettext ilmbase ];

  dontUseCmakeConfigure = true;

  # I rewrote the configure phase to get the $out references evaluated in
  # cmakeFlags
  configurePhase = ''
    set -x
    mkdir -p build;
    cd build
    eval -- "cmake .. $cmakeFlags"
    set +x
    '';
  postInstall = ''
    ensureDir "$out/nix-support"
    echo "${enblendenfuse} ${autopanosiftc}" > $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

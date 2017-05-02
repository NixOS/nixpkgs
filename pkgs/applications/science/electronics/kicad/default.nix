{ stdenv, fetchurl, fetchbzr, cmake, mesa, wxGTK, zlib, libX11, gettext, glew, cairo, curl, openssl, boost, pkgconfig, doxygen }:

stdenv.mkDerivation rec {
  name = "kicad-${series}";
  series = "4.0";
  version = "4.0.6";

  srcs = [
    (fetchurl {
      url = "https://code.launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
      sha256 = "1612lkr1p5sii2c4q8zdm6m4kmdylcq8hkd1mzr6b7l3g70sqz79";
    })

    (fetchurl {
      url = "http://downloads.kicad-pcb.org/libraries/kicad-library-${version}.tar.gz";
      sha256 = "16f47pd6f0ddsdxdrp327nr9v05gl8c24d0qypq2aqx5hdjmkp7f";
    })

    (fetchurl {
      url = "http://downloads.kicad-pcb.org/libraries/kicad-footprints-${version}.tar.gz";
      sha256 = "0vmgqhdw05k5fdnqv42grnvlz7v75g9md82jp2d3dvw2zw050lfb";
    })
  ];

  sourceRoot = "kicad-${version}";

  cmakeFlags = ''
    -DKICAD_SKIP_BOOST=ON
    -DKICAD_BUILD_VERSION=${version}
    -DKICAD_REPO_NAME=stable
  '';

  enableParallelBuilding = true; # often fails on Hydra: fatal error: pcb_plot_params_lexer.h: No such file or directory

  buildInputs = [ cmake mesa wxGTK zlib libX11 gettext glew cairo curl openssl boost pkgconfig doxygen ];

  # They say they only support installs to /usr or /usr/local,
  # so we have to handle this.
  patchPhase = ''
    sed -i -e 's,/usr/local/kicad,'$out,g common/gestfich.cpp
  '';

  postUnpack = ''
    pushd $(pwd)
  '';

  postInstall = ''
    popd

    pushd kicad-library-*
    cmake -DCMAKE_INSTALL_PREFIX=$out
    make $MAKE_FLAGS
    make install
    popd

    pushd kicad-footprints-*
    mkdir -p $out/share/kicad/modules
    cp -R *.pretty $out/share/kicad/modules/
    popd
  '';


  meta = {
    description = "Free Software EDA Suite";
    homepage = "http://www.kicad-pcb.org/";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

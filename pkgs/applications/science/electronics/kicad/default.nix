{ stdenv, fetchurl, fetchbzr, cmake, libGLU_combined, wxGTK, zlib, libX11, gettext, glew, cairo, curl, openssl, boost, pkgconfig, doxygen }:

stdenv.mkDerivation rec {
  name = "kicad-${version}";
  series = "4.0";
  version = "4.0.7";

  srcs = [
    (fetchurl {
      url = "https://code.launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
      sha256 = "1hgxan9321szgyqnkflb0q60yjf4yvbcc4cpwhm0yz89qrvlq1q9";
    })

    (fetchurl {
      url = "http://downloads.kicad-pcb.org/libraries/kicad-library-${version}.tar.gz";
      sha256 = "1azb7v1y3l6j329r9gg7f4zlg0wz8nh4s4i5i0l9s4yh9r6i9zmv";
    })

    (fetchurl {
      url = "http://downloads.kicad-pcb.org/libraries/kicad-footprints-${version}.tar.gz";
      sha256 = "08qrz5zzsb5127jlnv24j0sgiryd5nqwg3lfnwi8j9a25agqk13j";
    })
  ];

  sourceRoot = "kicad-${version}";

  cmakeFlags = ''
    -DKICAD_SKIP_BOOST=ON
    -DKICAD_BUILD_VERSION=${version}
    -DKICAD_REPO_NAME=stable
  '';

  enableParallelBuilding = true; # often fails on Hydra: fatal error: pcb_plot_params_lexer.h: No such file or directory

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake libGLU_combined wxGTK zlib libX11 gettext glew cairo curl openssl boost doxygen ];

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
    homepage = http://www.kicad-pcb.org/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    hydraPlatforms = []; # 'output limit exceeded' error on hydra
  };
}

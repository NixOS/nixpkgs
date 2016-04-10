{ stdenv, fetchurl, fetchbzr, cmake, mesa, wxGTK, zlib, libX11, gettext, glew, cairo, openssl, boost, pkgconfig, doxygen }:

stdenv.mkDerivation rec {
  name = "kicad-${series}";
  series = "4.0";
  version = "4.0.2";

  srcs = [
    (fetchurl {
      url = "https://code.launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
      sha256 = "1fcf91fmxj6ha3mm6gzdb0px50j58m80p8wrncm8ca9shj36kbif";
    })

    (fetchurl {
      url = "http://downloads.kicad-pcb.org/libraries/kicad-library-${version}.tar.gz";
      sha256 = "1xk9sxxb3d42chdysqmvizrjcbm0467q7nsq5cahq3j1hci49m6l";
    })

    (fetchurl {
      url = "http://downloads.kicad-pcb.org/libraries/kicad-footprints-${version}.tar.gz";
      sha256 = "0vrzykgxx423iwgz6186bi8724kmbi5wfl92gfwb3r6mqammgwpg";
    })
  ];
  
  sourceRoot = "kicad-${version}";

  cmakeFlags = ''
    -DCMAKE_BUILD_TYPE=Release
    -DKICAD_SKIP_BOOST=ON
    -DKICAD_BUILD_VERSION=${version}
    -DKICAD_REPO_NAME=stable
  '';

  enableParallelBuilding = true; # often fails on Hydra: fatal error: pcb_plot_params_lexer.h: No such file or directory

  buildInputs = [ cmake mesa wxGTK zlib libX11 gettext glew cairo openssl boost pkgconfig doxygen ];

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

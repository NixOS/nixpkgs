{ stdenv, fetchgit, fetchurl, qt4, pkgconfig, expat, cairo, boost, glew,
  openexr, ffmpeg, opencolorio, openimageio, imagemagick }:

let
  version = "1.2.1";
  CImg = fetchurl {
    url = https://raw.githubusercontent.com/dtschump/CImg/d89fbcf399b3663ce3ebac2ee387642fd64014b6/CImg.h;
    sha256 = "065sbx8dkywkrimc0l0vpq7dy7m9y6jlaq84x5ngys661j2nnslv";
  };
  plugins = {
    misc = fetchgit {
      url = https://github.com/devernay/openfx-misc.git;
      rev = "refs/tags/${version}";
      sha256 = "0zbwyxblkcyyyj45szhr2vhrbjwlpgcxm24pvp5048ns5rwxwbbh";
      deepClone = true;
    };
    io = fetchgit {
      url = https://github.com/MrKepzie/openfx-io.git;
      rev = "refs/tags/${version}";
      sha256 = "1krndh8yp8lxns28425sivfa6svwac1lfgdlhz2ki0i4kqw2vzh7";
      deepClone = true;
    };
    arena = fetchgit {
      url = https://github.com/olear/openfx-arena.git;
      rev = "refs/tags/1.9.0";
      sha256 = "1c51c002z234v994w2xlnzid71kkgk91n0i9yyq8sali7ib1234d";
      deepClone = true;
    };
  };
in
stdenv.mkDerivation {
  inherit version;
  name = "natron-${version}";
  src = fetchgit {
    url = https://github.com/MrKepzie/Natron.git;
    rev = "refs/tags/${version}";
    sha256 = "10p3lnw986diqjdfc4b5zlinm74sp0xa1akypwngjknqs79pap6b";
    deepClone = true;
  };

  buildInputs = [
    qt4 pkgconfig expat cairo boost glew openexr ffmpeg opencolorio openimageio
    imagemagick
  ];

  prePatch = ''
    mkdir plugins

    cp -r ${plugins.misc} plugins/openfx-misc
    chmod -R u+w plugins/openfx-misc
    cp ${CImg} plugins/openfx-misc/CImg/CImg.h

    cp -r ${plugins.io} plugins/openfx-io
    chmod -R u+w plugins/openfx-io

    cp -r ${plugins.arena} plugins/openfx-arena
    chmod -R u+w plugins/openfx-arena
  '';

  configurePhase = ''
    # From INSTALL_LINUX.md
    cat > config.pri << EOF
    boost: LIBS += -lboost_serialization
    expat: LIBS += -lexpat
    expat: PKGCONFIG -= expat
    EOF

    qmake
  '';

  buildPhase = ''
    make
    # TODO: It might be better have separate outputs and symlink the paths.
    make -C plugins/openfx-misc
    make -C plugins/openfx-io
    make -C plugins/openfx-arena
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp App/Natron $out/bin/

    mkdir -p $out/share
    cp -r Gui/Resources/OpenColorIO-Configs $out/share/

    mkdir -p $out/Plugins

    cp -r plugins/openfx-misc/CImg/*/CImg.ofx.bundle $out/Plugins/
    cp -r plugins/openfx-misc/Misc/*/Misc.ofx.bundle $out/Plugins/

    cp -r plugins/openfx-io/IO/*/IO.ofx.bundle $out/Plugins/

    cp -r plugins/openfx-arena/Bundle/*/Arena.ofx.bundle $out/Plugins/
  '';

  meta = with stdenv.lib; {
    description = "Node-graph based, open-source compositing software";
    longDescription = ''
      Node-graph based, open-source compositing software. Similar in
      functionalities to Adobe After Effects and Nuke by The Foundry.
    '';
    homepage = https://natron.inria.fr/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ maintainers.puffnfresh ];
    platforms = platforms.linux;
  };
}

{ lib, stdenv, fetchurl, qtbase, qmake, makeWrapper, qtscript, gcc, flex, bison, qtdeclarative, gnutar }:

stdenv.mkDerivation {
  name = "awesomebump-5.1";

  src = fetchurl {
    url = https://github.com/kmkolasinski/AwesomeBump/archive/Winx32v5.1.tar.gz;
    sha256 = "04s0jj9gfw1rfr82ga2vw6x1jy00ca9p9s3hh31q3k5h6vg5ailn";
  };

  buildInputs = [ qtbase qtscript qtdeclarative flex bison gnutar ];

  nativeBuildInputs = [ qmake makeWrapper ];

  buildPhase = ''
    cd Sources/utils/QtnProperty
    tar xf "${fetchurl { url = "https://github.com/kmkolasinski/QtnProperty/archive/00e1a9a7cdf6fa84d1b0a35efe752bc2e4a6be1f.tar.gz"; sha256 = "0fdny0khm6jb5816d5xsijp26xrkz2ksz8w9pv1x4hf32l48s9yn"; } }"
    mv QtnProperty-*/* .
    rm -r QtnProperty-*
    alias
    $QMAKE Property.pro -r TOP_SRC_DIR=$(pwd)
    make
    cd ../../../
    $QMAKE
    make
    cp -vr workdir/`cat workdir/current`/bin/AwesomeBump Bin
  '';

  installPhase =
    ''
      d=$out/libexec/AwesomeBump
      mkdir -p $d $out/bin
      cp Bin/AwesomeBump $d/
      cp -prd Bin/Configs Bin/Core $d/

      # AwesomeBump expects to find Core and Configs in its current
      # directory.
      makeWrapper $d/AwesomeBump $out/bin/AwesomeBump \
        --run "cd $d"
    '';

  # RPATH in /tmp hack
  preFixup = ''
    rm -r $NIX_BUILD_TOP/__nix_qt5__
  '';

  meta = {
    homepage = https://github.com/kmkolasinski/AwesomeBump;
    description = "A program to generate normal, height, specular or ambient occlusion textures from a single image";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
  };
}

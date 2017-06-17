{ stdenv, fetchFromGitHub, qt5, bzip2, mesa_glu, lib3ds, levmar, muparser, unzip }:

stdenv.mkDerivation rec {
  version = "2016.12";
  name = "meshlab-${version}";

  # Should be kept in sync with what the meshlab `version` needs
  # according to the release notes.
  vcglibVersion = "1.0.1";

  # Meshlab needs a copy of vcglib *next* to the directory that contains
  # its own source tree, so we fetch both meshlab and vcglib with `srcs` here.
  #
  # Note we use a separate copy of vcglib instead of the one in nixpkgs
  # because Meshlab typically wants a specific one and we don't want to
  # constrain the one in nixpkgs to the one that meshlab demands.
  #
  # Further, the directory *needs* to be called `vcglib`, because meshlab
  # has hardcoded paths like `../../../vcglib` in its source.
  # That's why we rename it in the `buildPhase`.
  srcs =
    [
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "meshlab";
        rev = "v${version}";
        sha256 = "0srrp7zhi86dsg4zsx1615gr26barz38zdl8s03zq6vm1dgzl3cc";
      })
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "vcglib";
        rev = "v${vcglibVersion}";
        sha256 = "0jh8jc8rn7rci8qr3q03q574fk2hsc3rllysck41j8xkr3rmxz2f";
      })
    ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    mv vcglib-v${vcglibVersion}-src vcglib

    cd meshlab-v${version}-src

    mkdir -p "$out/include"
    export NIX_LDFLAGS="-rpath $out/opt/meshlab $NIX_LDFLAGS"

    export QMAKE_FLAGS="-spec linux-g++ CONFIG+=release CONFIG+=qml_release CONFIG+=c++11 QMAKE_CXXFLAGS+=-fPIC QMAKE_CXXFLAGS+=-std=c++11 QMAKE_CXXFLAGS+=-fpermissive QMAKE_CXXFLAGS+=-fopenmp QMAKE_LFLAGS+=-lgomp LIBS+=-L$PWD/lib/linux-g++"

    set -x

    cd src
    pushd external

    qmake -recursive external.pro $QMAKE_FLAGS
    make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}

    popd

    echo "Fixing io_txt.pro case insensitivity (Unix is case sensitive)"
    mv plugins_experimental/io_TXT/io_txt.pro plugins_experimental/io_TXT/io_TXT.pro

    qmake -recursive meshlab_full.pro $QMAKE_FLAGS
    make ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES} -l''${NIX_BUILD_CORES}}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/meshlab $out/bin $out/lib
    pushd distrib
    cp -R * $out/opt/meshlab
    popd
    ln -s $out/opt/meshlab/meshlab $out/bin/meshlab

    runHook postInstall
  '';

  sourceRoot = ".";

  buildInputs = [
    unzip
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtscript
    qt5.qtxmlpatterns
    mesa_glu
  ];

  meta = {
    description = "System for the processing and editing of unstructured 3D triangular meshes";
    homepage = http://www.meshlab.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = stdenv.isLinux && stdenv.isi686;
  };
}

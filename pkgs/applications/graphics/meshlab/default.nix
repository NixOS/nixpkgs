{ fetchFromGitHub, libGLU, llvmPackages, qtbase, qtscript, qtxmlpatterns }:

let
  meshlabRev = "d596d7c086c51fbdfb56050f9c30b55dd0286d4c";
  vcglibRev = "6c3c940e34327322507c703889f9f1cfa73ab183";
  # ^ this should be the latest commit in the vcglib devel branch at the time of the meshlab revision

  stdenv = llvmPackages.stdenv; # only building with clang seems to be tested upstream
in stdenv.mkDerivation {
  name = "meshlab-20180627-beta";

  srcs =
    [
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "meshlab";
        rev = meshlabRev;
        sha256 = "0xi7wiyy0yi545l5qvccbqahlcsf70mhx829gf7bq29640si4rax";
        name = "meshlab-${meshlabRev}";
      })
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "vcglib";
        rev = vcglibRev;
        sha256 = "0jfgjvf21y9ncmyr7caipy3ardhig7hh9z8miy885c99b925hhwd";
        name = "vcglib-${vcglibRev}";
      })
    ];

  sourceRoot = "meshlab-${meshlabRev}";

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  patches = [ ./fix-20180627-beta.patch ];

  buildPhase = ''
    # MeshLab has ../vcglib hardcoded everywhere, so move the source dir
    mv ../vcglib-${vcglibRev} ../vcglib

    cd src
    export NIX_LDFLAGS="-rpath $out/opt/meshlab $NIX_LDFLAGS"
    export QMAKESPEC="linux-clang"

    pushd external
    qmake -recursive external.pro
    buildPhase
    popd
    qmake -recursive meshlab_full.pro
    buildPhase
  '';

  installPhase = ''
    mkdir -p $out/opt/meshlab $out/bin
    cp -Rv distrib/* $out/opt/meshlab
    ln -s $out/opt/meshlab/meshlab $out/bin/meshlab
    ln -s $out/opt/meshlab/meshlabserver $out/bin/meshlabserver
  '';

  buildInputs = [ libGLU llvmPackages.openmp qtbase qtscript qtxmlpatterns ];

  meta = {
    description = "A system for processing and editing 3D triangular meshes.";
    homepage = http://www.meshlab.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

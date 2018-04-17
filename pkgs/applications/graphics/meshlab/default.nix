{ stdenv, fetchFromGitHub, libGLU, qtbase, qtscript, qtxmlpatterns }:

let
  meshlabRev = "5700f5474c8f90696a8925e2a209a0a8ab506662";
  vcglibRev = "a8e87662b63ee9f4ded5d4699b28d74183040803";
in stdenv.mkDerivation {
  name = "meshlab-2016.12";

  srcs =
    [
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "meshlab";
        rev = meshlabRev;
        sha256 = "0srrp7zhi86dsg4zsx1615gr26barz38zdl8s03zq6vm1dgzl3cc";
        name = "meshlab-${meshlabRev}";
      })
      (fetchFromGitHub {
        owner = "cnr-isti-vclab";
        repo = "vcglib";
        rev = vcglibRev;
        sha256 = "0jh8jc8rn7rci8qr3q03q574fk2hsc3rllysck41j8xkr3rmxz2f";
        name = "vcglib-${vcglibRev}";
      })
    ];

  sourceRoot = "meshlab-${meshlabRev}";

  patches = [ ./fix-2016.02.patch ];

  hardeningDisable = [ "format" ];
  enableParallelBuilding = true;

  buildPhase = ''
    # MeshLab has ../vcglib hardcoded everywhere, so move the source dir
    mv ../vcglib-${vcglibRev} ../vcglib

    cd src
    export NIX_LDFLAGS="-rpath $out/opt/meshlab $NIX_LDFLAGS"

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

  buildInputs = [ libGLU qtbase qtscript qtxmlpatterns ];

  meta = {
    description = "A system for processing and editing 3D triangular meshes.";
    homepage = http://www.meshlab.net/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

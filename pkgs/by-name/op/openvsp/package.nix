{
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  pkg-config,
  python3,
  eigen,
  fltk,
  glm,
  glew,
  cminpack,
  libxml2,
  graphviz,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "openvsp";
  version = "3.40.1";

  src = fetchFromGitHub {
    owner = "OpenVSP";
    repo = "OpenVSP";
    rev = "OpenVSP_${version}";
    hash = "sha256-PfXqnd75D06vER7X5w+VOm12mvLbcSe4sxmhtwBmPps=";
  };

  nativeBuildInputs = [
    cmake
    python3
    git
  ];

  # swig & doxygen are not included as the build would fail since it tries to call
  # "swig -doxygen" which fails Make as this is not a valid command.
  # Seems like an upstream problem.
  buildInputs = [
    cminpack
    eigen
    fltk
    glew
    glm
    graphviz
    libxml2
  ];

  configurePhase = ''
    mkdir -p build buildlibs

    pushd buildlibs

    cmake \
      -DVSP_USE_SYSTEM_ADEPT2=false \
      -DVSP_USE_SYSTEM_CLIPPER2=false \
      -DVSP_USE_SYSTEM_CMINPACK=false \
      -DVSP_USE_SYSTEM_CODEELI=false \
      -DVSP_USE_SYSTEM_CPPTEST=false \
      -DVSP_USE_SYSTEM_DELABELLA=false \
      -DVSP_USE_SYSTEM_EIGEN=false \
      -DVSP_USE_SYSTEM_EXPRPARSE=false \
      -DVSP_USE_SYSTEM_FLTK=false \
      -DVSP_USE_SYSTEM_GLEW=false \
      -DVSP_USE_SYSTEM_GLM=false \
      -DVSP_USE_SYSTEM_LIBIGES=false \
      -DVSP_USE_SYSTEM_LIBXML2=false \
      -DVSP_USE_SYSTEM_OPENABF=false \
      -DVSP_USE_SYSTEM_PINOCCHIO=false \
      -DVSP_USE_SYSTEM_STEPCODE=false \
      -DVSP_USE_SYSTEM_TRIANGLE=false \
      $src/Libraries \
      -DCMAKE_BUILD_TYPE=Release

    make -j$cores
    popd

    pushd build
    cmake $src/src/ -DVSP_LIBRARY_PATH=$PWD/../buildlibs -DCMAKE_BUILD_TYPE=Release -DVSP_CPACK_GEN=DEB
    popd
  '';

  buildPhase = ''
    pushd build
    make -j$cores VERBOSE=1
    popd
  '';

  installPhase = ''
    pushd build
    mkdir -p $out/bin

    cp ./vsp/vsp $out/bin
    cp ./vsp/vspscript $out/bin
    cp ./src/vsp/vspviewer $out/bin
    cp ./src/vsp/vspaero $out/bin
    cp ./src/vsp/vsploads $out/bin
    cp ./vsp_aero/Solver/vspaero $out/bin
    cp ./vsp_aero/Solver/vspaero_complex $out/bin
    cp ./vsp_aero/Solver/vspaero_opt $out/bin
    cp ./vsp_aero/Solver/vspaero_adjoint $out/bin
    cp ./vsp_aero/Viewer/vspviewer $out/bin
    cp ./vsp_aero/Adb2Load/vsploads $out/bin

    popd
  '';

  meta = {
    description = "Parametric aircraft geometry tool";
    homepage = "https://openvsp.org/";
    license = lib.licenses.nasa13;
    maintainers = with lib.maintainers; [ kekschen ];
    mainProgram = "vsp";
  };
}

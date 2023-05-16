<<<<<<< HEAD
{ mkDerivation, lib, fetchFromGitHub, cmake, boost179, ceres-solver, eigen,
  freeimage, glog, libGLU, glew, qtbase,
  config,
  cudaSupport ? config.cudaSupport, cudaPackages }:
=======
{ mkDerivation, lib, fetchFromGitHub, cmake, boost17x, ceres-solver, eigen,
  freeimage, glog, libGLU, glew, qtbase,
  cudaSupport ? false, cudaPackages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

assert cudaSupport -> cudaPackages != { };

let
<<<<<<< HEAD
  boost_static = boost179.override { enableStatic = true; };
=======
  boost_static = boost17x.override { enableStatic = true; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # TODO: migrate to redist packages
  inherit (cudaPackages) cudatoolkit;
in
mkDerivation rec {
  version = "3.7";
  pname = "colmap";
  src = fetchFromGitHub {
     owner = "colmap";
     repo = "colmap";
     rev = version;
     hash = "sha256-uVAw6qwhpgIpHkXgxttKupU9zU+vD0Za0maw2Iv4x+I=";
  };

  # TODO: rm once the gcc11 issue is closed, https://github.com/colmap/colmap/issues/1418#issuecomment-1049305256
  cmakeFlags = lib.optionals cudaSupport [
    "-DCUDA_ENABLED=ON"
    "-DCUDA_NVCC_FLAGS=--std=c++14"
  ];

  buildInputs = [
    boost_static ceres-solver eigen
    freeimage glog libGLU glew qtbase
  ] ++ lib.optionals cudaSupport [
    cudatoolkit
  ];

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  meta = with lib; {
    description = "COLMAP - Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
       COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
       with a graphical and command-line interface.
    '';
    homepage = "https://colmap.github.io/index.html";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lebastr ];
  };
}

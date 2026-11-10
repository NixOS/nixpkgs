{
  lib,
  stdenv,
  fetchFromGitHub,
  cudaPackages,
}:

stdenv.mkDerivation {
  pname = "nvidia-optical-flow-sdk";
  version = "2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "NVIDIAOpticalFlowSDK";
    rev = "edb50da3cf849840d680249aa6dbef248ebce2ca";
    hash = "sha256-/7VH017Fv6BPgc6Ggs7vwtlnqz/SIEQhlFxQniaoYEM=";
  };

  # # We only need the header files. The library files are
  # # in the nvidia_x11 driver.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp -R * $out/include

    runHook postInstall
  '';

  # Makes setupCudaHook propagate nvidia-optical-flow-sdk together with cuda
  # packages. Currently used by opencv4.cxxdev, hopefully can be removed in the
  # future
  nativeBuildInputs = [
    cudaPackages.markForCudatoolkitRootHook
  ];

  meta = {
    description = "Nvidia optical flow headers for computing the relative motion of pixels between images";
    homepage = "https://developer.nvidia.com/opticalflow-sdk";
    license = lib.licenses.bsd3; # applies to the header files only
    platforms = lib.platforms.all;
  };
}

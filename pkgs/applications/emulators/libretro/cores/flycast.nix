{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  cmake,
  libGL,
  libGLU,
}:
mkLibretroCore {
  core = "flycast";
  version = "0-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "4886dcb1c20cd4a85627cc4970d9d01cdf1c2d7d";
    hash = "sha256-Lp0MCf8MbqfeSdp6qrWi+q1xgatKl+8HDbTSd5xuzLM=";
    fetchSubmodules = true;
  };

  extraNativeBuildInputs = [ cmake ];
  extraBuildInputs = [
    libGL
    libGLU
  ];
  cmakeFlags = [ "-DLIBRETRO=ON" ];
  makefile = "Makefile";

  meta = {
    description = "Flycast libretro port";
    homepage = "https://github.com/flyinghead/flycast";
    license = lib.licenses.gpl2Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}

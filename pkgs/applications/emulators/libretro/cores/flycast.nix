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
<<<<<<< HEAD
  version = "0-unstable-2025-12-29";
=======
  version = "0-unstable-2025-11-22";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
<<<<<<< HEAD
    rev = "4886dcb1c20cd4a85627cc4970d9d01cdf1c2d7d";
    hash = "sha256-Lp0MCf8MbqfeSdp6qrWi+q1xgatKl+8HDbTSd5xuzLM=";
=======
    rev = "1666eb0875613ee16b04e08be8ed89c27dbd5c25";
    hash = "sha256-uQvr4C8iO+3FXh6ki+Rgv7Y/+p1WHwXuqy9Xyq4gSeo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

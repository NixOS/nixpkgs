{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  replaceVars,
  addDriverRunpath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvpl";
<<<<<<< HEAD
  version = "2.16.0";
=======
  version = "2.15.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libvpl";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-TbneMexrGShBE83WRCHvECucG2/eYMtljwb3yvCTP7k=";
=======
    hash = "sha256-aCoyIHgX3ftlk0CKg/cXNAVjuGI8GMT358GoiyaNjnI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  patches = [
    (replaceVars ./opengl-driver-lib.patch {
      inherit (addDriverRunpath) driverLink;
    })
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Intel Video Processing Library";
    homepage = "https://intel.github.io/libvpl/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Intel Video Processing Library";
    homepage = "https://intel.github.io/libvpl/";
    license = licenses.mit;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})

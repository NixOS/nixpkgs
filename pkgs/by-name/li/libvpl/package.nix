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
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "libvpl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-51kl9w1xqldQXGWbk6bveS2jMZWQOz/gYP/hPXDk/7M=";
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

  meta = with lib; {
    description = "Intel Video Processing Library";
    homepage = "https://intel.github.io/libvpl/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
})

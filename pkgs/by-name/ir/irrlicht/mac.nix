{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  version,
  linuxSrc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "irrlicht-mac";
  inherit version;

  src = fetchFromGitHub {
    owner = "quiark";
    repo = "IrrlichtCMake";
    rev = "523a5e6ef84be67c3014f7b822b97acfced536ce";
    hash = "sha256-scV1eiLWG1aTUNwW528hAzCjN+xvDKHh5cTQL3y2UIE=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  postUnpack = ''
    cp -r ${linuxSrc}/* $sourceRoot/
    chmod -R 777 $sourceRoot
  '';

  patches = [ ./mac_device.patch ];

  cmakeFlags = [
    "-DIRRLICHT_STATIC_LIBRARY=ON"
    "-DIRRLICHT_BUILD_EXAMPLES=OFF"
    "-DIRRLICHT_INSTALL_MEDIA_FILES=OFF"
    "-DIRRLICHT_ENABLE_X11_SUPPORT=OFF"
    "-DIRRLICHT_BUILD_TOOLS=OFF"
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://irrlicht.sourceforge.net/";
    license = lib.licenses.zlib;
    description = "Open source high performance realtime 3D engine written in C++";
    platforms = lib.platforms.darwin;
    broken = true;
  };
})

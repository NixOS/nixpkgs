{
  lib,
  stdenv,
  darwin,
  fetchurl,
  openal,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freealut";
  version = "1.1.0";

  src = fetchurl {
    url = "http://www.openal.org/openal_webstf/downloads/freealut-${finalAttrs.version}.tar.gz";
    sha256 = "0kzlil6112x2429nw6mycmif8y6bxr2cwjcvp18vh6s7g63ymlb0";
  };

  buildInputs = [
    openal
  ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.frameworks.OpenAL;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "http://openal.org/";
    description = "Free implementation of OpenAL's ALUT standard";
    mainProgram = "freealut-config";
    license = lib.licenses.lgpl2;
    pkgConfigModules = [ "freealut" ];
    platforms = lib.platforms.unix;
  };
})

{
  lib,
  stdenv,
  fetchurl,
  testers,
  static ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjpeg";
  version = "9f";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${finalAttrs.version}.tar.gz";
    hash = "sha256-BHBcEQyyRpyqeftx+6PXv4NJFHBulkGkWJSFwfgyVls=";
  };

  configureFlags = lib.optional static "--enable-static --disable-shared";

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    homepage = "https://www.ijg.org/";
    description = "Library that implements the JPEG image file format";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.free;
    pkgConfigModules = [ "libjpeg" ];
    platforms = lib.platforms.unix;
  };
})

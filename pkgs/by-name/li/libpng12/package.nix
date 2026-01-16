{
  lib,
  stdenv,
  fetchurl,
  zlib,
  testers,
}:

assert stdenv.hostPlatform == stdenv.buildPlatform -> zlib != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "libpng";
  version = "1.2.59";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${finalAttrs.version}.tar.xz";
    hash = "sha256-tGNfFbitzMitCTTupIXvWcxMriTQ8DAKmpQeUZdP/Mc=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace pngconf.h --replace-fail '<fp.h>' '<math.h>'
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  propagatedBuildInputs = [ zlib ];

  configureFlags = [ "--enable-static" ];

  postInstall = ''mv "$out/bin" "$dev/bin"'';

  passthru = {
    inherit zlib;

    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Official reference implementation for the PNG file format";
    homepage = "http://www.libpng.org/pub/png/libpng.html";
    license = lib.licenses.libpng;
    maintainers = [ ];
    branch = "1.2";
    pkgConfigModules = [
      "libpng"
      "libpng12"
    ];
    platforms = lib.platforms.unix;
  };
})

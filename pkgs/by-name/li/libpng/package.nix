{
  lib,
  stdenv,
  fetchurl,
  zlib,
  apngSupport ? true,
  testers,
  darwin,
}:

assert zlib != null;

let
  patchVersion = "1.6.50";
  patch_src = fetchurl {
    url = "mirror://sourceforge/libpng-apng/libpng-${patchVersion}-apng.patch.gz";
    hash = "sha256-aH3cDHyxKKPqWOFZtRKSUlN8J+3gwyqT8R8DEn8MAWU=";
  };
  whenPatched = lib.optionalString apngSupport;

  # libpng is a dependency of xcbuild. Avoid an infinite recursion by using a bootstrap stdenv
  # that does not propagate xcrun.
  stdenv' = if stdenv.hostPlatform.isDarwin then darwin.bootstrapStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "libpng" + whenPatched "-apng";
  version = "1.6.53";

  src = fetchurl {
    url = "mirror://sourceforge/libpng/libpng-${finalAttrs.version}.tar.xz";
    hash = "sha256-HT+4zMKTLQSqNmPiLvXvSQJENw9OVo14UBZQaHeNmNQ=";
  };
  postPatch =
    whenPatched "gunzip < ${patch_src} | patch -Np1"
    + lib.optionalString stdenv.hostPlatform.isFreeBSD ''

      sed -i 1i'int feenableexcept(int __mask);' contrib/libtests/pngvalid.c
    '';

  outputs = [
    "out"
    "dev"
    "man"
  ];
  outputBin = "dev";

  propagatedBuildInputs = [ zlib ];

  doCheck = true;

  passthru = {
    inherit zlib;

    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description =
      "Official reference implementation for the PNG file format" + whenPatched " with animation patch";
    homepage = "http://www.libpng.org/pub/png/libpng.html";
    changelog = "https://github.com/pnggroup/libpng/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.libpng2;
    pkgConfigModules = [
      "libpng"
      "libpng16"
    ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ vcunat ];
  };
})

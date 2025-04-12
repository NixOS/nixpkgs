{
  lib,
  stdenv,
  fetchurl,
  # This also disables building tests.
  # on static windows cross-compile they fail to build
  doCheck ? with stdenv.hostPlatform; !(isWindows && isStatic),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libconfig";
  version = "1.7.3";

  src = fetchurl {
    url = "https://hyperrealm.github.io/${finalAttrs.pname}/dist/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-VFFm1srAN3RDgdHpzFpUBQlOe/rRakEWmbz/QLuzHuc=";
  };

  inherit doCheck;

  configureFlags =
    lib.optional (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isStatic) "--disable-examples"
    ++ lib.optional (!finalAttrs.doCheck) "--disable-tests";

  cmakeFlags = lib.optionals (!finalAttrs.doCheck) [ "-DBUILD_TESTS:BOOL=OFF" ];

  meta = {
    homepage = "https://hyperrealm.github.io/libconfig/";
    description = "C/C++ library for processing configuration files";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ stv0g ];
    platforms = lib.platforms.all;
  };
})

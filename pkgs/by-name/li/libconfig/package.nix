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
  version = "1.8.2";

  src = fetchurl {
    url = "https://hyperrealm.github.io/libconfig/dist/libconfig-${finalAttrs.version}.tar.gz";
    hash = "sha256-5Z/7kC3Vcx1dTk+4HTuYlpdhX+q3Lf18MGGBZ7kaQu4=";
  };

  inherit doCheck;

  configureFlags =
    lib.optional (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isStatic) "--disable-examples"
    ++ lib.optional (!finalAttrs.finalPackage.doCheck) "--disable-tests";

  cmakeFlags = lib.optionals (!finalAttrs.finalPackage.doCheck) [ "-DBUILD_TESTS:BOOL=OFF" ];

  meta = {
    homepage = "https://hyperrealm.github.io/libconfig/";
    changelog = "https://github.com/hyperrealm/libconfig/blob/v${finalAttrs.version}/ChangeLog";
    description = "C/C++ library for processing configuration files";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ stv0g ];
    platforms = lib.platforms.all;
  };
})

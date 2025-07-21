{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  # This also disables building tests.
  # on static windows cross-compile they fail to build
  doCheck ? with stdenv.hostPlatform; !(isWindows && isStatic),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libconfig";
  version = "1.8";

  src = fetchurl {
    url = "https://hyperrealm.github.io/libconfig/dist/libconfig-${finalAttrs.version}.tar.gz";
    hash = "sha256-BR4V3Q6QfESQXzF5M/VIcxTypW6MZybIMEzpkIhIUKo=";
  };

  patches = [
    # Fix tests on i686-linux:
    #   https://github.com/hyperrealm/libconfig/pull/260
    # TODO: remove with a next release
    (fetchpatch {
      name = "32-bit-tests.patch";
      url = "https://github.com/hyperrealm/libconfig/commit/b90c45a18110fcca415d00a98ff79c908c42544b.patch";
      hash = "sha256-8CihXbpKx0Rn0CFxyP6+f6m8vUYehCl/1EtTo98VpfM=";
    })
  ];

  inherit doCheck;

  configureFlags =
    lib.optional (stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isStatic) "--disable-examples"
    ++ lib.optional (!finalAttrs.finalPackage.doCheck) "--disable-tests";

  cmakeFlags = lib.optionals (!finalAttrs.finalPackage.doCheck) [ "-DBUILD_TESTS:BOOL=OFF" ];

  meta = {
    homepage = "https://hyperrealm.github.io/libconfig/";
    description = "C/C++ library for processing configuration files";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ stv0g ];
    platforms = lib.platforms.all;
  };
})

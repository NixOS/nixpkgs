{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  testers,

  static ? stdenv.hostPlatform.isStatic,

  lz4,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-blosc";
  version = "1.21.6";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YelKkEXAh27J0Mq1BExGuKNCYBgJCc3nwmmWLr4ZfVI=";
  };

  patches = [
    # backport patch for cmake 4 compatibility
    (fetchpatch {
      url = "https://github.com/Blosc/c-blosc/commit/051b9d2cb9437e375dead8574f66d80ebce47bee.patch?full_index=1";
      hash = "sha256-90dUd8KQqq+uVbngfoKF45rmFxbLVVgZjg0Xfc/vpcc=";
    })
    # backport patch for gcc 15 compatibility
    (fetchpatch {
      url = "https://github.com/Blosc/c-blosc/commit/774f6a0ebaa0c617f7f13ccf6bc89d17eba04654.patch?full_index=1";
      hash = "sha256-C5nwMXjmlxkBvN1/4fuGTgFANqTD/+ikxYPLo1fwm6Q=";
    })
  ];

  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    sed -i -E \
      -e '/^libdir[=]/clibdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      -e '/^includedir[=]/cincludedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      blosc.pc.in
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    lz4
    zlib
    zstd
  ];

  cmakeFlags = [
    "-DBUILD_STATIC=${if static then "ON" else "OFF"}"
    "-DBUILD_SHARED=${if static then "OFF" else "ON"}"

    "-DPREFER_EXTERNAL_LZ4=ON"
    "-DPREFER_EXTERNAL_ZLIB=ON"
    "-DPREFER_EXTERNAL_ZSTD=ON"

    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BENCHMARKS=OFF"
    "-DBUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  doCheck = !static;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Blocking, shuffling and loss-less compression library";
    homepage = "https://www.blosc.org";
    changelog = "https://github.com/Blosc/c-blosc/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "blosc" ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,

  static ? stdenv.hostPlatform.isStatic,

  lz4,
  zfp,
  zlib-ng,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-blosc2";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc2";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-X/LR88pHbCk0TPu0oGPsg9phXmwnHlXCxdxd+Wa69UY=";
  };

  # https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    sed -i -E \
      -e '/^libdir[=]/clibdir=@CMAKE_INSTALL_FULL_LIBDIR@' \
      -e '/^includedir[=]/cincludedir=@CMAKE_INSTALL_FULL_INCLUDEDIR@' \
      blosc2.pc.in
  '';

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    lz4
    zfp
    zlib-ng
    zstd
  ];

  cmakeFlags = [
    "-DBUILD_STATIC=${if static then "ON" else "OFF"}"
    "-DBUILD_SHARED=${if static then "OFF" else "ON"}"

    "-DBLOSC_DEPENDENCY_MODE=EXTERNAL"

    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_BENCHMARKS=OFF"
    "-DBUILD_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
  ];

  doCheck = !static;
  # possibly https://github.com/Blosc/c-blosc2/issues/432
  enableParallelChecking = false;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "Blosc2" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Fast, compressed, persistent binary data store library for C";
    homepage = "https://www.blosc.org";
    changelog = "https://github.com/Blosc/c-blosc2/releases/tag/v${finalAttrs.version}";
    pkgConfigModules = [ "blosc2" ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ris ];
  };
})

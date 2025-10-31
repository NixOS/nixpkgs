{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  minizip,
  openssl,
  python3,
  zlib,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxlsxwriter";
  version = "1.2.3";

  outputs = [
    "out"
  ]
  ++ lib.optionals stdenv.hostPlatform.hasSharedLibraries [
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "libxlsxwriter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1FUJLsnx0ZNTT66sK7/gbZVo6Se85nbYvtEyoxeOHTI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    minizip
    openssl
    zlib
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_MINIZIP=ON"
    "-DUSE_OPENSSL_MD5=ON"
    "-DUSE_DTOA_LIBRARY=ON"
    (lib.cmakeBool "BUILD_SHARED_LIBS" stdenv.hostPlatform.hasSharedLibraries)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.doCheck)
  ];

  # TEST 428/429 worksheet:worksheet_table15 *** buffer overflow detected ***: terminated
  hardeningDisable = [ "fortify3" ];

  doCheck = true;

  nativeCheckInputs = [
    python3.pkgs.pytest
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "C library for creating Excel XLSX files";
    homepage = "https://libxlsxwriter.github.io/";
    changelog = "https://github.com/jmcnamara/libxlsxwriter/blob/${finalAttrs.src.tag}/Changes.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "xlsxwriter" ];
  };
})

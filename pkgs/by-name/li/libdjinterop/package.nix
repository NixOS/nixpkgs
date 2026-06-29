{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  testers,
  validatePkgConfig,
  boost,
  cmake,
  howard-hinnant-date,
  ninja,
  sqlite,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdjinterop";

  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "xsco";
    repo = "libdjinterop";
    rev = finalAttrs.version;
    hash = "sha256-Uiz2VZef0+H9NfPgOPT1XVBKCiTXC/n8VKVveXEy40c=";
  };

  patches = [
    # https://github.com/xsco/libdjinterop/pull/188
    # adds options to use system howard-hinnant-date and sqlite_modern_cpp
    # additionally bumps version in CMakeLists.txt, fixed in postPatch
    (fetchpatch2 {
      url = "https://github.com/xsco/libdjinterop/commit/d21f713440633e41d37df14c8e5cc16be7595a7a.patch";
      hash = "sha256-QPgSU1BYl+RAb3sJn5LkbqovhBgCLYw44+d8pr7Tx3M=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
    --replace-fail "VERSION 0.27.2" "VERSION 0.27.1"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    validatePkgConfig
  ];

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    boost
    howard-hinnant-date
    sqlite
    zlib
  ];

  propagatedBuildInputs = [
    howard-hinnant-date
    sqlite
    zlib
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "SYSTEM_DATE_H" true)
  ];

  doCheck = true;

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "DjInterop" ];
    };
    pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
  };

  meta = {
    homepage = "https://github.com/xsco/libdjinterop";
    description = "C++ library for access to DJ record libraries";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "djinterop" ];
  };
})

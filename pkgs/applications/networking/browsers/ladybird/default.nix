{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, unzip
, wrapQtAppsHook
, libxcrypt
, qtbase
, nixosTests
}:

stdenv.mkDerivation {
  pname = "ladybird";
  version = "unstable-2023-03-06";

  src = fetchFromGitHub {
    owner = "SerenityOS";
    repo = "serenity";
    rev = "2258fc273c9eb0db404a8020b8621fab31d1f7f7";
    hash = "sha256-bwyk2RWXAPte+h0gGHuVN9raemHsKrYC/32wkZtYfYU=";
  };

  sourceRoot = "source/Ladybird";

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "MACOSX_BUNDLE TRUE" "MACOSX_BUNDLE FALSE"
    # https://github.com/SerenityOS/serenity/issues/17062
    substituteInPlace main.cpp \
      --replace "./SQLServer/SQLServer" "$out/bin/SQLServer"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    unzip
    wrapQtAppsHook
  ];

  buildInputs = [
    libxcrypt
    qtbase
  ];

  cmakeFlags = [
    # Disable network operations
    "-DENABLE_TIME_ZONE_DATABASE_DOWNLOAD=false"
    "-DENABLE_UNICODE_DATABASE_DOWNLOAD=false"
  ];

  env.NIX_CFLAGS_COMPILE = toString ([
    "-Wno-error"
  ] ++ lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.targetPlatform.darwinSdkVersion "11.0") [
    # error: use of undeclared identifier 'aligned_alloc'
    "-include mm_malloc.h"
    "-Daligned_alloc=_mm_malloc"
  ]);

  # https://github.com/NixOS/nixpkgs/issues/201254
  NIX_LDFLAGS = lib.optionalString (stdenv.isLinux && stdenv.isAarch64 && stdenv.cc.isGNU) "-lgcc";

  # https://github.com/SerenityOS/serenity/issues/10055
  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath $out/lib $out/bin/ladybird
  '';

  passthru.tests = {
    nixosTest = nixosTests.ladybird;
  };

  meta = with lib; {
    description = "A browser using the SerenityOS LibWeb engine with a Qt GUI";
    homepage = "https://github.com/awesomekling/ladybird";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.unix;
  };
}

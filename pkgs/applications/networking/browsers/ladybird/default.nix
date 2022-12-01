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

let serenity = fetchFromGitHub {
  owner = "SerenityOS";
  repo = "serenity";
  rev = "a0f3e2c9a2b82117aa7c1a3444ad0d31baa070d5";
  hash = "sha256-8Xde59ZfdkTD39mYSv0lfFjBHFDWTUwfozE+Q9Yq6C8=";
};
in
stdenv.mkDerivation {
  pname = "ladybird";
  version = "unstable-2022-09-29";

  # Remember to update `serenity` too!
  src = fetchFromGitHub {
    owner = "SerenityOS";
    repo = "ladybird";
    rev = "d69ad7332477de33bfd1963026e057d55c6f222d";
    hash = "sha256-XQj2Bohk8F6dGCAManOmmDP5b/SqEeZXZbLDYPfvi2E=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "MACOSX_BUNDLE TRUE" "MACOSX_BUNDLE FALSE"
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
    "-DSERENITY_SOURCE_DIR=${serenity}"
    # Disable network operations
    "-DENABLE_TIME_ZONE_DATABASE_DOWNLOAD=false"
    "-DENABLE_UNICODE_DATABASE_DOWNLOAD=false"
  ];

  # error: use of undeclared identifier 'aligned_alloc'
  NIX_CFLAGS_COMPILE = toString (lib.optionals (stdenv.isDarwin && lib.versionOlder stdenv.targetPlatform.darwinSdkVersion "11.0") [
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

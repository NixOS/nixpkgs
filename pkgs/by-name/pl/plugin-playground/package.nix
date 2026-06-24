{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  darwin,
  rustPlatform,
  cargo,
  rustc,
  corrosion,
  apple-sdk_15,
}:

let
  slintSrc = fetchFromGitHub {
    owner = "slint-ui";
    repo = "slint";
    tag = "v1.16.1";
    hash = "sha256-3M0uHMGJq249yUtIBiwx3zZODc+OH61QbhOW2gwQR8g=";
  };
in
stdenv.mkDerivation {
  pname = "plugin-playground";
  version = "1.0-pre";

  src = fetchFromGitHub {
    owner = "CoreBedtime";
    repo = "playground";
    rev = "72d411df1a6c9c0770698b99d4f757e4bc69871e";
    hash = "sha256-+Q4tizoQIidGm23sKeR+prJWRA4wspEt3pC112yrgrQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    darwin.sigtool
    rustPlatform.cargoSetupHook
    cargo
    rustc
    corrosion
  ];

  buildInputs = [
    apple-sdk_15
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postUnpack = ''
    cp -R ${slintSrc} $sourceRoot/slintSrc
    chmod -R +w $sourceRoot/slintSrc
    cp $sourceRoot/slintSrc/Cargo.lock $sourceRoot/Cargo.lock

    substituteInPlace $sourceRoot/slintSrc/api/cpp/CMakeLists.txt \
      --replace-fail 'list(APPEND slint_compiler_features "jemalloc")' ""
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "--timestamp=none" ""
  '';

  cmakeFlags = [
    "-DBUILD_CONFIGURATOR=ON"
    "-DFETCHCONTENT_SOURCE_DIR_SLINT=../slintSrc"
  ];

  postInstall = ''
    rm -rf $out/include
    rm -rf $out/lib
    rm -f $out/bin/slint-compiler
  '';

  meta = {
    description = "General-purpose runtime tweak system for macOS Apple Silicon";
    homepage = "https://github.com/CoreBedtime/playground";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aspauldingcode ];
    platforms = [
      "aarch64-darwin"
    ];
  };
}

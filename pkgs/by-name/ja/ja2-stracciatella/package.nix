{
  stdenv,
  lib,
  fetchurl,
  fetchFromGitHub,
  cmake,
  python3,
  rustPlatform,
  cargo,
  rustc,
  SDL2,
  fltk,
  lua5_3,
  miniaudio,
  rapidjson,
  sol2,
  gtest,
}:

let
  stringTheory = fetchurl {
    url = "https://github.com/zrax/string_theory/archive/3.8.tar.gz";
    hash = "sha256-mq7pW3qRZs03/SijzbTl1txJHCSW/TO+gvRLWZh/11M=";
  };

  magicEnum = fetchurl {
    url = "https://github.com/Neargye/magic_enum/archive/v0.8.2.zip";
    hash = "sha256-oQ+mUDB8YJULcSploz+0bprJbqclhc+p/Pmsn1AsAes=";
  };
in
stdenv.mkDerivation rec {
  pname = "ja2-stracciatella";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    tag = "v${version}";
    hash = "sha256-zMCFDMSKcsYz5LjW8UJbBlSmuJX6ibr9zIS3BgZMgAg=";
  };

  patches = [
    # Note: this patch is only relevant for darwin
    ./dont-use-vendored-sdl2.patch
  ];

  postPatch = ''
    # Patch dependencies that are usually loaded by url
    substituteInPlace dependencies/lib-string_theory/builder/CMakeLists.txt.in \
      --replace-fail ${stringTheory.url} file://${stringTheory}
    substituteInPlace dependencies/lib-magic_enum/getter/CMakeLists.txt.in \
      --replace-fail ${magicEnum.url} file://${magicEnum}
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    python3
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    SDL2
    fltk
    lua5_3
    rapidjson
    sol2
    gtest
  ];

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-5KZa5ocn6Q4qUeRmm7Tymgg09dr6aZoAuJvtF32CXNg=";
  };

  cmakeFlags = [
    (lib.cmakeBool "FLTK_SKIP_FLUID" true) # otherwise `find_package(FLTK)` fails
    (lib.cmakeBool "LOCAL_LUA_LIB" false)
    (lib.cmakeBool "LOCAL_MINIAUDIO_LIB" false)
    (lib.cmakeFeature "MINIAUDIO_INCLUDE_DIR" "${miniaudio}")
    (lib.cmakeBool "LOCAL_RAPIDJSON_LIB" false)
    (lib.cmakeBool "LOCAL_SOL_LIB" false)
    (lib.cmakeBool "LOCAL_GTEST_LIB" false)
    (lib.cmakeFeature "EXTRA_DATA_DIR" "${placeholder "out"}/share/ja2")
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    HOME=$(mktemp -d) $out/bin/ja2 -unittests
  '';

  meta = {
    # Fails to build on x86_64-linux as of 2025-03-16 and potentially earlier
    broken = true;
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = "https://ja2-stracciatella.github.io/";
    maintainers = [ ];
  };
}

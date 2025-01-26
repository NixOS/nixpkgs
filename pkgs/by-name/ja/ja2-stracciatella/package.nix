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
  rapidjson,
  gtest,
}:

let
  stringTheoryUrl = "https://github.com/zrax/string_theory/archive/3.1.tar.gz";
  stringTheory = fetchurl {
    url = stringTheoryUrl;
    sha256 = "1flq26kkvx2m1yd38ldcq2k046yqw07jahms8a6614m924bmbv41";
  };
in
stdenv.mkDerivation rec {
  pname = "ja2-stracciatella";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    rev = "v${version}";
    sha256 = "0m6rvgkba29jy3yq5hs1sn26mwrjl6mamqnv4plrid5fqaivhn6j";
  };

  patches = [
    # Note: this patch is only relevant for darwin
    ./dont-use-vendored-sdl2.patch
  ];

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
    rapidjson
    gtest
  ];

  cargoRoot = "rust";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-zkctR16QIjCTiDmrhFqPPOThbPwsm0T0nlnCekkXNN8=";
  };

  preConfigure = ''
    # Patch dependencies that are usually loaded by url
    substituteInPlace dependencies/lib-string_theory/builder/CMakeLists.txt.in \
      --replace ${stringTheoryUrl} file://${stringTheory}

    cmakeFlagsArray+=("-DLOCAL_RAPIDJSON_LIB=OFF" "-DLOCAL_GTEST_LIB=OFF" "-DEXTRA_DATA_DIR=$out/share/ja2")
  '';

  # error: 'uint64_t' does not name a type
  # gcc13 and above don't automatically include cstdint
  env.CXXFLAGS = "-include cstdint";

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=/tmp $out/bin/ja2 -unittests
  '';

  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = "https://ja2-stracciatella.github.io/";
  };
}

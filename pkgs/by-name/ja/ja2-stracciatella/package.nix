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
  stringTheory = fetchurl {
    url = "https://github.com/zrax/string_theory/archive/3.1.tar.gz";
    hash = "sha256-gexVFxGpkmCMQrpCJQ/g2BsCpsCsUTSaD1X0PacRmLo=";
  };
in
stdenv.mkDerivation rec {
  pname = "ja2-stracciatella";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "ja2-stracciatella";
    repo = "ja2-stracciatella";
    tag = "v${version}";
    hash = "sha256-0li4o8KutJjpJdviqqqhMvNqhNVBw4L98DIJtebb2VQ=";
  };

  patches = [
    # Note: this patch is only relevant for darwin
    ./dont-use-vendored-sdl2.patch
  ];

  postPatch = ''
    # Patch dependencies that are usually loaded by url
    substituteInPlace dependencies/lib-string_theory/builder/CMakeLists.txt.in \
      --replace-fail ${stringTheory.url} file://${stringTheory}
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

  cmakeFlags = [
    (lib.cmakeBool "LOCAL_RAPIDJSON_LIB" false)
    (lib.cmakeBool "LOCAL_GTEST_LIB" false)
    (lib.cmakeFeature "EXTRA_DATA_DIR" "${placeholder "out"}/share/ja2")
  ];

  # error: 'uint64_t' does not name a type
  # gcc13 and above don't automatically include cstdint
  env.CXXFLAGS = "-include cstdint";

  doInstallCheck = true;

  installCheckPhase = ''
    HOME=$(mktemp -d) $out/bin/ja2 -unittests
  '';

  meta = {
    description = "Jagged Alliance 2, with community fixes";
    license = "SFI Source Code license agreement";
    homepage = "https://ja2-stracciatella.github.io/";
    maintainers = [ ];
  };
}

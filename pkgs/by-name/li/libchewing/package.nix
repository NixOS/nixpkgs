{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sqlite,
  corrosion,
  rustPlatform,
  cargo,
  rustc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libchewing";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "libchewing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5aeAsvTiUMTm+ibNfJI57rzSUpJB7luhA/aWmTcnBj4=";
  };

  # ld: unknown option: -version-script
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(CMAKE_C_COMPILER_ID MATCHES GNU|^Clang)" "if((CMAKE_C_COMPILER_ID MATCHES GNU|^Clang) AND NOT APPLE)"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-LTuUhQ0ZeyGloNvVs+6OGjFvPdBsQNZupwC8QTjUfyk=";
  };

  nativeBuildInputs = [
    cmake
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    sqlite
    corrosion
  ];

  meta = {
    description = "Intelligent Chinese phonetic input method";
    homepage = "https://chewing.im/";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ ShamrockLee ];
    platforms = lib.platforms.all;
    # compile time tools init_database, dump_database are built for host
    broken = !stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  };
})

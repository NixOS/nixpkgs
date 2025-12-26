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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libchewing";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "chewing";
    repo = "libchewing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rUkLwE5PvFcMxTwb2zVzWaa20D3ZW1MXl3Cra+Wim04=";
  };

  # ld: unknown option: -version-script
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(CMAKE_C_COMPILER_ID MATCHES GNU|^Clang)" "if((CMAKE_C_COMPILER_ID MATCHES GNU|^Clang) AND NOT APPLE)"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-+BmJOouajL3ib08t96TAHtNXBX48wq614LSbcSgYpIM=";
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

  passthru.updateScript = nix-update-script { };

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

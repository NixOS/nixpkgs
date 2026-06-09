{
  lib,
  stdenv,
  fetchFromCodeberg,
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
  version = "0.12.0";

  src = fetchFromCodeberg {
    owner = "chewing";
    repo = "libchewing";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-+oSO1HgLMF5+UcY+2NwQjPmspGqaPYuI7mdvSLrhkNg=";
  };

  # ld: unknown option: -version-script
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "if(CMAKE_C_COMPILER_ID MATCHES GNU|^Clang)" "if((CMAKE_C_COMPILER_ID MATCHES GNU|^Clang) AND NOT APPLE)"
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-TcNhoGCN+S/Tt3IdysVnGmXNl+hXQoWMppp8yN9N0NY=";
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

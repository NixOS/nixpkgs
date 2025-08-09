{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  zstd,
  pkg-config,
  jq,
  cargo,
  rustc,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "decasify";
  version = "0.10.1";

  src = fetchurl {
    url = "https://github.com/alerque/decasify/releases/download/v${finalAttrs.version}/decasify-${finalAttrs.version}.tar.zst";
    hash = "sha256-XPl4HfhkwhHRkfc64BTafeHgLK1lB4UHKP6loLn5Ruc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    dontConfigure = true;
    nativeBuildInputs = [ zstd ];
    hash = "sha256-rbFacCK/HU2D7QbVfMgKr9VevfutBJJtbXbKodTmkrc=";
  };

  nativeBuildInputs = [
    zstd
    pkg-config
    jq
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  outputs = [
    "out"
    "doc"
    "man"
    "dev"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Utility to change the case of prose strings following natural language style guides";
    longDescription = ''
      A CLI utility to cast strings to title-case (and other cases) according
      to locale specific style guides including Turkish support.
    '';
    homepage = "https://github.com/alerque/decasify";
    changelog = "https://github.com/alerque/decasify/raw/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      alerque
    ];
    license = lib.licenses.lgpl3Only;
    mainProgram = "decasify";
  };
})

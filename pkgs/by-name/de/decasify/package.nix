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
  version = "0.8.0";

  src = fetchurl {
    url = "https://github.com/alerque/decasify/releases/download/v${finalAttrs.version}/decasify-${finalAttrs.version}.tar.zst";
    hash = "sha256-HTUAb/yL3H4B/n/Ecd/fDpnTYiqwco/E07sa6pFIIU4=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    nativeBuildInputs = [ zstd ];
    hash = "sha256-bD8MYufI87j//7dIAnCzmp4yoOaT81Zv1i7rjWpjPlc=";
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

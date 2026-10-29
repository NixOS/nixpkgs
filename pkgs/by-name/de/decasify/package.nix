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

  # nativeInstallCheckInputs
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "decasify";
  version = "0.11.4";

  src = fetchurl {
    url = "https://github.com/alerque/decasify/releases/download/v${finalAttrs.version}/decasify-${finalAttrs.version}.tar.zst";
    hash = "sha256-N+VnUMfMvnJfRN0GXG28Fw+Sr6lQwzXn+CVvIbo7j8w=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    dontConfigure = true;
    nativeBuildInputs = [ zstd ];
    hash = "sha256-nkuKeVGqn/stlezRDIf6vGQSqNzVCnrkvuFXqkLdvdE=";
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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

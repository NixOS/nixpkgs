{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_file";
  version = "0.28.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_file";
    rev = "cdb9f6de0ef32949d5e7f2945c4b2fd3f2f1a8b3";
    hash = "sha256-2P8MzTWKC2lU0s8fRaK/z5tfBTgKLqmQG80NE7aylXU=";
  };

  cargoHash = "sha256-RO6EXkhciYyUbmHoJc2l2WX1XUR2IIbxfE0Y5e//t0Q=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Nushell plugin to inspect file formats using magic bytes";
    mainProgram = "nu_plugin_file";
    homepage = "https://github.com/fdncred/nu_plugin_file";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})

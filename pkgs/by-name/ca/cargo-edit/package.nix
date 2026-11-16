{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-edit";
  version = "0.13.14";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Hp4hAaVVTBUwPMdCD27uqLUpj40zLN1RNaee1IsFVSY=";
  };

  cargoHash = "sha256-bDYIsDj5+t55ET9CE7DTyKqIv8Jp0ghPGMkDTTH6cQU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zlib
  ];

  passthru.updateScript = nix-update-script { };

  doCheck = false; # integration tests depend on changing cargo config

  meta = {
    description = "Utility for managing cargo dependencies from the command line";
    homepage = "https://github.com/killercup/cargo-edit";
    changelog = "https://github.com/killercup/cargo-edit/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    mainProgram = "cargo-edit";
    maintainers = with lib.maintainers; [
      gerschtli
      jb55
      killercup
      matthiasbeyer
    ];
  };
})

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
  version = "0.13.13";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yaY6krZ+kt2g3Wnnzsw4P3xnpsaZuNwFfRk9GLvwps8=";
  };

  cargoHash = "sha256-Q4GDA81w0JR9rcpKSPe9Y+9HPpFdAvYP2RI+91R4NWE=";

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
    license = with lib.licenses; [
      asl20 # or
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

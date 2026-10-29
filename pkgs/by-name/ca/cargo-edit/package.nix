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
  version = "0.13.10";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = "cargo-edit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9CmbOIRHgYlc/bAN8BS5NyzfgRIzyneh/LC/sZFZUuo=";
  };

  cargoHash = "sha256-O1tY0RVH4FHr7kWJ8+BUyD7LzzqlaObO0dHwrsX2biQ=";

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

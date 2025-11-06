{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenvNoCC,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-plumbing";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-plumbing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x8xH7XH91FtOn5knVL7mkcDTGvXtVVL70HIi8V9z54o=";
  };

  cargoHash = "sha256-16rY8uk9ViEaYIqiZHHU1UApAdNXAETqgFzUWNto6po=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  doCheck = !stdenvNoCC.hostPlatform.isDarwin;

  meta = {
    description = "Proposed plumbing commands for cargo";
    homepage = "https://github.com/crate-ci/cargo-plumbing";
    changelog = "https://github.com/crate-ci/cargo-plumbing/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      secona
    ];
  };
})

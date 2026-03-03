{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  lib,
  zlib,
  git,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "magi";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "anddani";
    repo = "magi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3hJL2ewKEH5w5G4FOvXKjo9jXGQW3rQ14cEBE9+Rtzs=";
  };

  cargoHash = "sha256-vuLXA0W5MP9hylCb6nhml6EdC8WoFhjDQHJE18F+Mfo=";

  nativeBuildInputs = [ pkg-config ];
  nativeCheckInputs = [ git ];
  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  meta = {
    description = "Keyboard-driven Git TUI based on Magit";
    homepage = "https://github.com/anddani/magi";
    changelog = "https://github.com/anddani/magi/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anddani ];
    mainProgram = "magi";
  };
})

{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jocalsend";
  version = "1.6.1803";

  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag = finalAttrs.version;
    hash = "sha256-nrXUZb4Yi1ttEltzqKUnMLLr5cvhqCxW1iJyo1ErG0w=";
  };

  cargoHash = "sha256-0yFKJtwQikP6WRDVWgv7b9e0iUS9AdKpx6VTeNAQ4zs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    homepage = "https://git.kittencollective.com/nebkor/joecalsend";
    description = "Rust terminal client for Localsend";
    changelog = "https://git.kittencollective.com/nebkor/joecalsend/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ unfreeRedistributable ];
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "jocalsend";
  };
})

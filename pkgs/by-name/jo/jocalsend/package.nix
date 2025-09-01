{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jocalsend";
  version = "1.6.18033";

  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag = finalAttrs.version;
    hash = "sha256-q2fzi0NKfkjCwV7FD0PqXSHtJWQtvdvKx4WmhnZpKvg=";
  };

  cargoHash = "sha256-u9Ev/Qr/WN6OOaMXPesA3nmV3efKJA3/2YWm8S60PjU=";

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

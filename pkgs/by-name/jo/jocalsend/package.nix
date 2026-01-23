{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jocalsend";
  version = "1.618033988";

  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag = finalAttrs.version;
    hash = "sha256-nzsvVC1e8ENh0bpQwiogGew823NNmSNXN+VZZHfVFIY=";
  };

  cargoHash = "sha256-5V/a6rj08Ucu6S+SBukYQktWLVnnbXeoGan1oYTozHc=";

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

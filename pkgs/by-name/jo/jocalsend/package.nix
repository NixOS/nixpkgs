{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jocalsend";
  version = "1.61803398";

  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag = finalAttrs.version;
    hash = "sha256-7Gl+G4BN3CgF0c/AEhI1OvRhveqGeFNmGRI3XRf6rAo=";
  };

  cargoHash = "sha256-prT1wO3ctnTfMHfICFcihB739lN/QXPH3AamIR6dM9A=";

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

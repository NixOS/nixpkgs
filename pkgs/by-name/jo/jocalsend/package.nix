{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jocalsend";
  version = "1.6180339887";

  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "git.kittencollective.com";
    owner = "nebkor";
    repo = "joecalsend";
    tag = finalAttrs.version;
    hash = "sha256-sOgFOAJXX5mugjMfTICNrJHc/DRD5zdZsg/K4cbRjlQ=";
  };

  cargoHash = "sha256-UEzyy6SQ3ntJHeXivd6e8Xvr4aTdpfYrFMWqLjoBrJc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://git.kittencollective.com/nebkor/joecalsend";
    description = "Rust terminal client for Localsend";
    changelog = "https://git.kittencollective.com/nebkor/joecalsend/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "jocalsend";
  };
})

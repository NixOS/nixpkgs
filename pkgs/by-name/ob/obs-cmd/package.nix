{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yqj3G9oZeQdJjTWtkZtGkJYxLdxQ7i0CWZT04/Q3i6o=";
  };

  cargoHash = "sha256-rfC67Uht+SKK7vqavhqZVhl5MdmkvTBniLk6lg32uCI=";

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ramblurr ];
    mainProgram = "obs-cmd";
  };
})

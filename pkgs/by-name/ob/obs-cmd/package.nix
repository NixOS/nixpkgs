{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5WnlaCOm3ttZ0+xNCuR9AfiNytDnz1j+HcgGUZBYzqM=";
  };

  cargoHash = "sha256-qOZoHzymPvbOIhIQz1TuH7wKHsL2ZJjJcnqYb3Roxrc=";

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ramblurr ];
    mainProgram = "obs-cmd";
  };
})

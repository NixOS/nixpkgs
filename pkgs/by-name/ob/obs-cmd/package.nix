{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
  version = "0.30.1";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LBnizJnUqTCfAAmVR9piQeQGKvgAvylLwWZ6ARa3HAw=";
  };

  cargoHash = "sha256-Mb8IS9ahbKIYzlyAWiAFQCjOWRdrFXS/vyEl54OOlYw=";

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "obs-cmd";
  };
})

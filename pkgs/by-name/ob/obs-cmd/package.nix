{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xjtNQZDgo7DIUsoH0PNHbsgE+FSXYnqWXpISdiRqTKw=";
  };

  cargoHash = "sha256-AMy/QrC4rTajbj4ODhUkjCItNRROOe+lmhCBvMF+DTH0=";

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "obs-cmd";
  };
})

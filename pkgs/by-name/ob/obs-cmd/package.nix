{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "obs-cmd";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-67kMAUwgrQcGipsbKo0kubkVJA4/T4nfqghEZlhnvHU=";
  };

  cargoHash = "sha256-t0R2QMmNpLgqmqLVL4hgEcqN0xIUIK3gIwxZxzkupbQ=";

  meta = {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "obs-cmd";
  };
})

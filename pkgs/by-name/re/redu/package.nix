{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  restic,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redu";
  version = "0.2.16";

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cro9vdWq57IRLCwp5q7iWGfThEaBsQ/z9umHlKbFVz8=";
  };

  cargoHash = "sha256-g1UylYWQL741PxNBjhVg5pSBd8P4QKPujMWAkXbusRo=";

  buildInputs = [ restic ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ncdu for your restic repo";
    homepage = "https://github.com/drdo/redu";
    changelog = "https://github.com/drdo/redu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      alexfmpe
      drdo
    ];
    mainProgram = "redu";
  };
})

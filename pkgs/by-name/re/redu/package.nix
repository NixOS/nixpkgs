{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  restic,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redu";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "drdo";
    repo = "redu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ByXQ3tcvXbCUZwZ+e7WJVUUjvhMf0ivJJiswFlLap4I=";
  };

  cargoHash = "sha256-JnjXe2CHO9Namp++UI/V6ND2Y0/WQtaVA2EcUyXUnjQ=";

  buildInputs = [ restic ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ncdu for your restic repo";
    homepage = "https://github.com/drdo/redu";
    changelog = "https://github.com/drdo/redu/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ alexfmpe ];
    mainProgram = "redu";
  };
})

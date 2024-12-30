{
  lib,
  rustPlatform,
  fetchFromGitHub,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
  version = "0.9.1-unstable-2024-11-15";

  src = fetchFromGitHub {
    owner = "rsonquery";
    repo = "rsonpath";
    rev = "979e6374a68747dfba7b87b61bbe77951f749659";
    hash = "sha256-YQCbkdv7PRf5hVXAGUg6DrtaCLIyS9nUGXsl8XHpKZU=";
  };

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  cargoHash = "sha256-nv2dQ7JV+fJIW+AkKLJ1yauKog0bS7F62cXsqp1CoRo=";

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = cargoBuildFlags;

  meta = {
    description = "Experimental JSONPath engine for querying massive streamed datasets";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "rq";
  };
}

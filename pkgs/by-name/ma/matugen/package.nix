{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "matugen";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    tag = "v${version}";
    hash = "sha256-2VcdnUjIOEMQ87K5wv+Pbgko94PLygp1nrEYcVHk1v4=";
  };

  cargoHash = "sha256-HBAsCrD/njZUYkjcaUaTS7xMwfUWLpDXkpIPWSdCvqo=";

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
}

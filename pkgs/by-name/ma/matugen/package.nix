{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "matugen";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "InioX";
    repo = "matugen";
    rev = "refs/tags/v${version}";
    hash = "sha256-+UibbVz5CTisKMms/5VXGe39FYr56qzaEtX4TWQPkjk=";
  };

  cargoHash = "sha256-/SUbmgdCy+3qpmu+cpNV+D/39jZ4jOzxgXegCHk9pHc=";

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
}

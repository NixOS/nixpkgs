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
    tag = "v${version}";
    hash = "sha256-+UibbVz5CTisKMms/5VXGe39FYr56qzaEtX4TWQPkjk=";
  };

  cargoHash = "sha256-ZCH8ka740X/yRbn4Mbno63jZifPMEaDABsftS3juDTo=";

  meta = {
    description = "Material you color generation tool";
    homepage = "https://github.com/InioX/matugen";
    changelog = "https://github.com/InioX/matugen/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "matugen";
  };
}

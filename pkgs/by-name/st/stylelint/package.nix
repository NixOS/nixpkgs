{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage rec {
  pname = "stylelint";
  version = "16.23.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint";
    tag = version;
    hash = "sha256-kPqvrcIYxumy/SfW8sVqo2e72z32L4mgfAE79LS8BfE=";
  };

  npmDepsHash = "sha256-SJ1r2lINacrdFYUkjse4wx0EwFsFMVoeESzMKH2ijwU=";

  dontNpmBuild = true;

  meta = {
    description = "Mighty CSS linter that helps you avoid errors and enforce conventions";
    mainProgram = "stylelint";
    homepage = "https://stylelint.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}

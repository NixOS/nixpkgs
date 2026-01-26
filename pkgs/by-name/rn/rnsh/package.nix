{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "rnsh";
  version = "0.1.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "acehoss";
    repo = pname;
    tag = "release/v${version}";
    hash = "sha256-Dog5InfCRCxqe9pXpCAPdqGbEz2SvNOGq4BvR8oM05o=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [ rns ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/acehoss/rnsh";
    changelog = "https://github.com/acehoss/rnsh/releases/tag/${src.tag}";
    description = "Command-line utility that facilitates shell sessions over Reticulum";
    mainProgram = "rnsh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbit ];
  };
}

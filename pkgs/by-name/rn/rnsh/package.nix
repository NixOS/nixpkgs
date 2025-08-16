{
  lib,
  fetchFromGitHub,
  python3,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rnsh";
  version = "0.1.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "acehoss";
    repo = pname;
    tag = "release/v${version}";
    hash = "sha256-Dog5InfCRCxqe9pXpCAPdqGbEz2SvNOGq4BvR8oM05o=";
  };

  doCheck = true;

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    poetry-core
  ];

  dependencies = with python3.pkgs; [ rns ];

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

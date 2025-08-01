{
  python3Packages,
  fetchFromGitHub,
  lib,
}:
with python3Packages;
buildPythonPackage rec {
  pname = "rnsh";
  version = "0.1.5";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "acehoss";
    repo = pname;
    rev = "release/v${version}";
    hash = "sha256-Dog5InfCRCxqe9pXpCAPdqGbEz2SvNOGq4BvR8oM05o=";
  };

  doCheck = true;

  nativeBuildInputs = [
    setuptools-scm
    poetry-core
  ];

  dependencies = [
    rns
  ];

  meta = with lib; {
    homepage = "https://github.com/acehoss/rnsh";
    description = "command-line utility that facilitates shell sessions over Reticulum";
    mainProgram = "rnsh";
    license = licenses.mit;
    maintainers = with maintainers; [ qbit ];
  };
}

{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitxray";
  version = "1.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kulkansecurity";
    repo = "gitxray";
    rev = "refs/tags/${version}";
    hash = "sha256-sBDKRHNhRG0SUd9G0+iiKOB+lqzISi92itbZIT+j4ME=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ requests ];

  pythonImportsCheck = [ "gitxray" ];

  meta = {
    description = "Tool which leverages Public GitHub REST APIs for various tasks";
    homepage = "https://github.com/kulkansecurity/gitxray";
    changelog = "https://github.com/kulkansecurity/gitxray/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gitxray";
  };
}

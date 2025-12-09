{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitxray";
  version = "1.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kulkansecurity";
    repo = "gitxray";
    tag = version;
    hash = "sha256-jdN91oiKMr8ozjsQG2+lI55nPbjBa+ipWG9GYeFXCDw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ requests ];

  pythonImportsCheck = [ "gitxray" ];

  meta = {
    description = "Tool which leverages Public GitHub REST APIs for various tasks";
    homepage = "https://github.com/kulkansecurity/gitxray";
    changelog = "https://github.com/kulkansecurity/gitxray/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gitxray";
  };
}

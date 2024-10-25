{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "autobloody";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CravateRouge";
    repo = "autobloody";
    rev = "refs/tags/v${version}";
    hash = "sha256-0MwhdT9GYLcrdZSqszx1DC9lyz8K61lJZZCzeFfWB0E=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bloodyad
    neo4j
  ];

  # Tests require a test file which is not available in the current release
  doCheck = false;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "autobloody"
  ];

  meta = with lib; {
    description = "Tool to automatically exploit Active Directory privilege escalation paths";
    homepage = "https://github.com/CravateRouge/autobloody";
    changelog = "https://github.com/CravateRouge/autobloody/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "autobloody";
  };
}

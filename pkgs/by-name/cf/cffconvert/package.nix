{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cffconvert";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "citation-file-format";
    repo = "cffconvert";
    rev = version;
    hash = "sha256-DpnJRqveHsq3HgC0fXtZuL6SYO5nhJRaOTbaSwmEoVU=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = [
    python3.pkgs.click
    python3.pkgs.requests
    python3.pkgs.ruamel-yaml
    python3.pkgs.pykwalify
    python3.pkgs.jsonschema
  ];

  pythonImportsCheck = [ "cffconvert" ];

  meta = with lib; {
    description = "Command line program to validate and convert CITATION.cff files";
    homepage = "https://github.com/citation-file-format/cffconvert";
    changelog = "https://github.com/citation-file-format/cffconvert/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ wentasah ];
    mainProgram = "cffconvert";
  };
}

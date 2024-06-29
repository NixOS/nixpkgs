{
  lib,
  python3Packages,
  fetchFromGitHub,
  groff
}:
python3Packages.buildPythonApplication rec {
  pname = "cppman";
  version = "0-unstable-2024-02-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aitjcize";
    repo = "cppman";
    rev = "a3f3846b9ed40255e9683fc67782ed01ff97ffd0";
    hash = "sha256-tssUznPFrk5q2c9gc/OWFKWe4630XT0Gf1BbJ1Mao/A=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
  ];
  propagatedBuildInputs = [
    python3Packages.beautifulsoup4
    python3Packages.html5lib
    groff
  ];

  pythonImportsCheck = ["cppman"];

  meta = {
    description = "C++ 98/11/14 manual pages for Linux/MacOS";
    homepage = "https://github.com/aitjcize/cppman";
    changelog = "https://github.com/aitjcize/cppman/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lampros ];
    mainProgram = "cppman";
  };
}

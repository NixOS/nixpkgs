{ lib
, stdenv
, python3
, fetchFromGitHub
, qt6
}:

python3.pkgs.buildPythonApplication {
  pname = "retool";
  version = "2.02.2-unstable-2024-03-17";

  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unexpectedpanda";
    repo = "retool";
    rev = "30d547c7d04b8cbf7710b2037388bf18a00a0c22";
    hash = "sha256-5Tmi3eVJh9STP9A0dDNPDs4SlIWHw8sk+g1GgpnmqeE=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    qt6.wrapQtAppsHook
  ];

  pythonRelaxDeps = true;

  buildInputs = [
    qt6.qtbase
  ] ++
  lib.optionals (stdenv.isLinux) [
    qt6.qtwayland
  ];

  propagatedBuildInputs = with python3.pkgs; [
    alive-progress
    darkdetect
    lxml
    psutil
    pyside6
    strictyaml
    validators
  ];

  # Upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "A better filter tool for Redump and No-Intro dats";
    homepage = "https://github.com/unexpectedpanda/retool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thiagokokada ];
  };
}

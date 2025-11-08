{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "retool";
  version = "2.4.4";

  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unexpectedpanda";
    repo = "retool";
    tag = "v${version}";
    hash = "sha256-hWCMxWcjjFF5xg7WrF4wjwGneoQCEUp+4oe+CieElcQ=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    qt6.wrapQtAppsHook
  ];

  pythonRelaxDeps = true;

  buildInputs = [
    qt6.qtbase
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
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
    description = "Better filter tool for Redump and No-Intro dats";
    homepage = "https://github.com/unexpectedpanda/retool";
    changelog = "https://github.com/unexpectedpanda/retool/blob/${src.tag}/changelog.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thiagokokada ];
  };
}

{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "retool";
  version = "2.3.8";

  pyproject = true;
  disabled = python3.pkgs.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unexpectedpanda";
    repo = "retool";
    rev = "refs/tags/v${version}";
    hash = "sha256-KGBpGZAC0SjStp0aulxVRJMmNwlpvSG0i0rtZgvFCpc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    hatchling
    pythonRelaxDepsHook
    qt6.wrapQtAppsHook
  ];

  pythonRelaxDeps = true;

  buildInputs =
    [
      qt6.qtbase
    ]
    ++ lib.optionals (stdenv.isLinux) [
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

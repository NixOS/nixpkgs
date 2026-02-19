{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "retool";
  version = "2.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unexpectedpanda";
    repo = "retool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q1v/VPcKIMGcAtnELKUpVgRGPyMmL8zJr5RdOClCwoc=";
  };

  pythonRelaxDeps = true;

  build-system = with python3.pkgs; [ hatchling ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [
    qt6.qtbase
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    qt6.qtwayland
  ];

  dependencies = with python3.pkgs; [
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

  meta = {
    description = "Better filter tool for Redump and No-Intro dats";
    homepage = "https://github.com/unexpectedpanda/retool";
    changelog = "https://github.com/unexpectedpanda/retool/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ thiagokokada ];
  };
})

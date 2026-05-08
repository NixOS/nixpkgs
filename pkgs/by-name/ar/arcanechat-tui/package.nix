{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
  testers,
  arcanechat-tui,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "arcanechat-tui";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArcaneChat";
    repo = "arcanechat-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-seoXvlDG2xxdM9mAKe4Yo4juDslgrniv1LOTdXbplp0=";
  };

  build-system = with python3.pythonOnBuildForHost.pkgs; [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = true;

  dependencies = with python3Packages; [
    appdirs
    deltachat2
    urwid
    urwid-readline
  ];

  doCheck = false; # no tests implemented

  passthru.tests = {
    version = testers.testVersion rec {
      package = arcanechat-tui;
      command = ''
        HOME="$TEMP" ${lib.getExe package} --version
      '';
    };
  };

  meta = {
    description = "Lightweight Delta Chat client";
    homepage = "https://github.com/ArcaneChat/arcanechat-tui";
    license = lib.licenses.gpl3Plus;
    mainProgram = "arcanechat-tui";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})

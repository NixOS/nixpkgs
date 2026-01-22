{
  lib,
  python3,
  fetchFromGitHub,
  testers,
  arcanechat-tui,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "arcanechat-tui";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ArcaneChat";
    repo = "arcanechat-tui";
    tag = "v${version}";
    hash = "sha256-ARk0WkpJ2VhIdOHQzYmmsuherABNgqwjwnPWk92y9yA=";
  };

  build-system = with python3.pythonOnBuildForHost.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
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
}

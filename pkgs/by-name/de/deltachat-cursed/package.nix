{
  lib,
  python3,
  fetchFromGitHub,
  testers,
  deltachat-cursed,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deltachat-cursed";
  version = "0.9.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat-cursed";
    rev = "v${version}";
    hash = "sha256-z4JKe5soR4FdIn8hugxtnxQr/9V8m8a7QRzE1liIexc=";
  };

  build-system = with python3.pythonOnBuildForHost.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    appdirs
    deltachat2
    emoji
    notify-py
    setuptools # for pkg_resources
    urwid-readline
  ];

  doCheck = false; # no tests implemented

  passthru.tests = {
    version = testers.testVersion rec {
      package = deltachat-cursed;
      command = ''
        HOME="$TEMP" ${lib.getExe package} --version
      '';
    };
  };

  meta = with lib; {
    description = "Lightweight Delta Chat client";
    homepage = "https://github.com/adbenitez/deltachat-cursed";
    license = licenses.gpl3Plus;
    mainProgram = "curseddelta";
    maintainers = with maintainers; [ dotlambda ];
  };
}

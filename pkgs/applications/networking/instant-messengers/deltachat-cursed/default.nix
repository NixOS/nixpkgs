{ lib
, python3
, fetchFromGitHub
, testers
, deltachat-cursed
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deltachat-cursed";
  version = "0.8.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat-cursed";
    rev = "v${version}";
    hash = "sha256-1QNhNPa6ZKn0lGQXs/cmfdSFHscwlYwFC/2DpnMoHvY=";
  };

  nativeBuildInputs = with python3.pythonOnBuildForHost.pkgs; [
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    deltachat
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

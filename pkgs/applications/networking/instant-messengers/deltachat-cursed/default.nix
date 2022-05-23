{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deltachat-cursed";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat-cursed";
    rev = "v${version}";
    hash = "sha256-li6HsatiRJPVKKBBHyWhq2b8HhvDrOUiVT2tSupjuag=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = with python3.pkgs; [
    deltachat
    notify-py
    urwid-readline
  ];

  doCheck = false; # no tests implemented

  meta = with lib; {
    description = "Lightweight Delta Chat client";
    homepage = "https://github.com/adbenitez/deltachat-cursed";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

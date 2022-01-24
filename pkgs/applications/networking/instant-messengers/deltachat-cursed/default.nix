{ lib
, python3
, fetchFromGitHub
, wrapGAppsHook
, gobject-introspection
, libnotify
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deltachat-cursed";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat-cursed";
    rev = "v${version}";
    hash = "sha256-IZrTPnj6eX1qgEPnEiD9qmVkwn1SMK38gVKAJFgZNfw=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools-scm
    wrapGAppsHook
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  buildInputs = [
    gobject-introspection
    libnotify
  ];

  propagatedBuildInputs = with python3.pkgs; [
    deltachat
    notify-py
    pygobject3
    urwid-readline
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doCheck = false; # no tests implemented

  meta = with lib; {
    description = "Lightweight Delta Chat client";
    homepage = "https://github.com/adbenitez/deltachat-cursed";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}

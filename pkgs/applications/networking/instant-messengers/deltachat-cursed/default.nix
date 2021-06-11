{ lib
, python3
, fetchFromGitHub
, wrapGAppsHook
, gobject-introspection
, libnotify
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deltachat-cursed";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "adbenitez";
    repo = "deltachat-cursed";
    rev = "v${version}";
    sha256 = "0kbb7lh17dbkd85mcqf438qwk5masz2fxsy8ljdh23kis55nksh8";
  };

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = [
    gobject-introspection
    libnotify
  ];

  propagatedBuildInputs = with python3.pkgs; [
    deltachat
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

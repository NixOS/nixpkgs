{ lib
, python3
, fetchFromGitHub
, gettext
, glade
, gobject-introspection
, libappindicator
, wrapGAppsHook
, xorg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "green-recorder";
  version = "3.2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dvershinin";
    repo = "green-recorder";
    rev = version;
    hash = "sha256-w2jQo2nsem4AOW2PTRDdhGwdT8Ji62FoP7BiH8v+gLA=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    python3.pkgs.setuptools
    python3.pkgs.wheel
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    glade
    libappindicator
    pydbus
    pygobject3
    setuptools
    xorg.xdpyinfo
  ];

  meta = with lib; {
    description = "A simple screen recorder for Linux desktop. Supports GNOME Wayland & Xorg";
    homepage = "https://github.com/dvershinin/green-recorder";
    changelog = "https://github.com/dvershinin/green-recorder/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "green-recorder";
    platforms = platforms.linux;
  };
}

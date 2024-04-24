{ lib
, fetchFromGitHub
, python3Packages
, gobject-introspection
, libadwaita
, wrapGAppsHook4
, meson
, ninja
, desktop-file-utils
, pkg-config
, appstream
, libsecret
, gtk4
, gtksourceview5
}:

python3Packages.buildPythonApplication rec {
  pname = "errands";
  version = "45.1.9";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrvladus";
    repo = "Errands";
    rev = "refs/tags/${version}";
    hash = "sha256-q8vmT7XUx3XJjPfbEd/c3HrTENfopl1MqwT0x5OuG0c=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    meson
    ninja
    pkg-config
    appstream
    gtk4
  ];

  buildInputs = [
    libadwaita
    libsecret
    gtksourceview5
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    lxml
    caldav
    pycryptodomex
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Manage your tasks";
    homepage = "https://github.com/mrvladus/Errands";
    license = licenses.mit;
    mainProgram = "errands";
    maintainers = with maintainers; [ sund3RRR ];
  };
}

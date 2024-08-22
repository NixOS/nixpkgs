{
  lib,
  fetchFromGitHub,
  python3Packages,
  gobject-introspection,
  libadwaita,
  wrapGAppsHook4,
  meson,
  ninja,
  desktop-file-utils,
  pkg-config,
  appstream,
  libsecret,
  libportal,
  gtk4,
  gtksourceview5,
}:
python3Packages.buildPythonApplication rec {
  pname = "errands";
  version = "46.2.7";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "mrvladus";
    repo = "Errands";
    rev = "refs/tags/${version}";
    hash = "sha256-kPF6BS7qDFstCGadSB8MSvBy+T4PkG/wRisYAaIU6rY=";
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
    libportal
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

  meta = {
    description = "Manage your tasks";
    changelog = "https://github.com/mrvladus/Errands/releases/tag/${version}";
    homepage = "https://github.com/mrvladus/Errands";
    license = lib.licenses.mit;
    mainProgram = "errands";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      sund3RRR
    ];
  };
}

{
  lib,
  python3,
  fetchFromGitHub,
  desktop-file-utils,
  glib,
  gobject-introspection,
  gtk4,
  meson,
  ninja,
  wrapGAppsHook4,
  libadwaita,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smile";
  version = "2.9.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = "smile";
    rev = version;
    hash = "sha256-tXbRel+rtaE2zPO8NOc4X+Ktk4PdRHBMtpsGLbvuHZk=";
  };

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py

    substituteInPlace build-aux/meson/postinstall.py \
      --replace-fail gtk-update-icon-cache gtk4-update-icon-cache
  '';

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    glib # for glib-compile-resources
    gobject-introspection
    gtk4 # for gtk4-update-icon-cache
    meson
    ninja
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    manimpango
    pygobject3
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    changelog = "https://smile.mijorus.it/changelog";
    description = "An emoji picker for linux, with custom tags support and localization";
    downloadPage = "https://github.com/mijorus/smile";
    homepage = "https://mijorus.it/projects/smile/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "smile";
    maintainers = with lib.maintainers; [ koppor ];
  };
}

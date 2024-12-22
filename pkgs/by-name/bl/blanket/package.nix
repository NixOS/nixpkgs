{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  blueprint-compiler,
  desktop-file-utils,
  python3Packages,
  glib,
  gtk4,
  libadwaita,
  gobject-introspection,
  gst_all_1,
}:

python3Packages.buildPythonApplication rec {
  pname = "blanket";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "blanket";
    rev = version;
    hash = "sha256-mY7c5i0me7mMbD8c6eGJeaZpR8XI5QVL4n3M+j15Z1c=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  propagatedBuildInputs = with python3Packages; [ pygobject3 ];

  format = "other";

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
    substituteInPlace build-aux/meson/postinstall.py \
      --replace-fail gtk-update-icon-cache gtk4-update-icon-cache
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Listen to different sounds";
    homepage = "https://github.com/rafaelmardojai/blanket";
    license = lib.licenses.gpl3Plus;
    mainProgram = "blanket";
    maintainers =
      with lib.maintainers;
      [
        onny
      ]
      ++ lib.teams.gnome-circle.members;
    platforms = lib.platforms.linux;
  };
}

{
  lib,
  meson,
  ninja,
  pkg-config,
  gettext,
  fetchFromGitHub,
  python3,
  wrapGAppsHook3,
  gtk3,
  glib,
  desktop-file-utils,
  appstream-glib,
  adwaita-icon-theme,
  gobject-introspection,
  librsvg,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "piper";
  version = "0.8-unstable-2026-07-21";

  pyproject = false;

  src = fetchFromGitHub {
    owner = "libratbag";
    repo = "piper";
    rev = "452f46ce861948cacdf0f7948964e67a29d027b9";
    hash = "sha256-0PLf8YZmEV1SQcEMEa0fm9GZkrD8jvtNG+iIeqRkJJw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook3
    desktop-file-utils
    appstream-glib
    gobject-introspection
  ];
  buildInputs = [
    gtk3
    glib
    adwaita-icon-theme
    python3
    librsvg
  ];
  propagatedBuildInputs = with python3.pkgs; [
    lxml
    evdev
    pygobject3
  ];

  mesonFlags = [
    "-Druntime-dependency-checks=false"
  ];

  postPatch = ''
    chmod +x meson_install.sh # patchShebangs requires executable file
    patchShebangs meson_install.sh data/generate-piper-gresource.xml.py
  '';

  meta = {
    description = "GTK frontend for ratbagd mouse config daemon";
    mainProgram = "piper";
    homepage = "https://github.com/libratbag/piper";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mvnetbiz ];
    platforms = lib.platforms.linux;
  };
})

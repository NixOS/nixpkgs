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
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "blanket";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "rafaelmardojai";
    repo = "blanket";
    tag = version;
    hash = "sha256-LnHL/1DJXiKx9U+JkT4Wjx1vtTmKLpzZ8q6uLT5a2MY=";
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

  pyproject = false;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Listen to different sounds";
    changelog = "https://github.com/rafaelmardojai/blanket/releases/tag/${version}";
    homepage = "https://github.com/rafaelmardojai/blanket";
    license = lib.licenses.gpl3Plus;
    mainProgram = "blanket";
    maintainers = with lib.maintainers; [
      onny
    ];
    teams = [ lib.teams.gnome-circle ];
    platforms = lib.platforms.linux;
  };
}

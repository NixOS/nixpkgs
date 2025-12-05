{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  yt-dlp,
  gst_all_1,
  libadwaita,
  glib-networking,
}:
python3Packages.buildPythonApplication rec {
  pname = "jellyfingtk";
  version = "0-unstable-2025-10-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "asavage7";
    repo = "JellyfinGTK";
    rev = "2361bb6241edd0ab31694119f54c590f0759214f";
    hash = "sha256-QAthq/KNWQrp1AH4OyNU4OxGgZclFnltUB5gLYXyYhM=";
  };

  patches = [ ./pyproject_install.patch ];

  dependencies = with python3Packages; [
    mprisify
    requests
    ytmusicapi

    pylette
  ];

  build-system = with python3Packages; [
    setuptools
    pip
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    # needed for gstreamer https
    glib-networking
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  meta = {
    description = "Simple Jellyfin music player";
    homepage = "https://github.com/asavage7/JellyfinGTK";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "jellyfingtk";
  };
}

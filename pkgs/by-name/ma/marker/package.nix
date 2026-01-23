{
  stdenv,
  lib,
  fetchFromGitHub,
  itstool,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  gtksourceview,
  gtkspell3,
  webkitgtk_4_1,
  pandoc,
}:

stdenv.mkDerivation rec {
  pname = "marker";
  version = "2023.05.02";

  src = fetchFromGitHub {
    owner = "fabiocolacio";
    repo = "Marker";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-HhDhigQ6Aqo8R57Yrf1i69sM0feABB9El5R5OpzOyB0=";
  };

  patches = [
    # https://github.com/fabiocolacio/Marker/pull/427
    ./fix_incompatible_pointer_in_marker_window_init.patch
  ];

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    gtksourceview
    gtkspell3
    webkitgtk_4_1
    pandoc
  ];

  postPatch = ''
    meson rewrite kwargs set project / version '${version}'
  '';

  meta = {
    homepage = "https://fabiocolacio.github.io/Marker/";
    description = "Markdown editor for the Linux desktop made with GTK3";
    maintainers = with lib.maintainers; [
      trepetti
      aleksana
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/fabiocolacio/Marker/releases/tag/${version}";
    mainProgram = "marker";
  };
}

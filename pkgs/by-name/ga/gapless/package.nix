{
  lib,
  stdenv,
  fetchFromGitLab,
  desktop-file-utils,
  gitUpdater,
  gobject-introspection,
  gst_all_1,
  gtk4,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gapless";
  version = "4.6";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "neithern";
    repo = "g4music";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UzOmf0it0vazKo4PhAhaobJFZc5YKBLq7bcexatROOA=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
  ]
  ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Beautiful, fast, fluent, light weight music player written in GTK4";
    mainProgram = "g4music";
    homepage = "https://gitlab.gnome.org/neithern/g4music";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
})

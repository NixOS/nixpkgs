{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  gdk-pixbuf,
  granite7,
  gst_all_1,
  gtk4,
  libadwaita,
  libgee,
}:

stdenv.mkDerivation rec {
  pname = "elementary-videos";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    rev = version;
    hash = "sha256-3TpPgMd4dABhvnnmHHQCHDvuSdC5rWxGvaXPg20/Mrs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    granite7
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    # https://github.com/elementary/videos/issues/356
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-rs # GTK 4 Sink
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.videos";
  };
}

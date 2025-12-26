{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  glib,
  dbus,
  gtk3,
  libappindicator-gtk3,
  gst_all_1,
  librsvg,
  wrapGAppsHook3,
  pulseaudioSupport ? true,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audio-recorder";
  version = "3.3.4";

  src = fetchurl {
    name = "audio-recorder-${finalAttrs.version}.tar.gz";
    url = "https://launchpad.net/~audio-recorder/+archive/ubuntu/ppa/+files/audio-recorder_${finalAttrs.version}%7Ejammy.tar.gz";
    hash = "sha256-RQ8zAT98EdVgdHENX0WDDYGvu7XjoB7f2FPv2JYJqug=";
  };

  # https://bugs.launchpad.net/audio-recorder/+bug/1784622
  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    dbus
    gtk3
    librsvg
    libappindicator-gtk3
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ])
  ++ lib.optional pulseaudioSupport libpulseaudio;

  meta = {
    description = "Audio recorder for GNOME and Unity Desktops";
    mainProgram = "audio-recorder";
    longDescription = ''
      This program allows you to record your favourite music or audio to a file.
      It can record audio from your system soundcard, microphones, browsers and
      webcams. Put simply; if it plays out of your loudspeakers you can record it.
      This program has a timer that can start, stop or pause recording on certain
      conditions such as audio level, file size and clock time. This recorder can
      automatically record your Skype calls. It supports several audio (output)
      formats such as OGG audio, Flac, MP3 and WAV.
    '';
    homepage = "https://launchpad.net/~audio-recorder";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.msteen ];
  };
})

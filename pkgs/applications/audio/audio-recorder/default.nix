{ lib, stdenv, fetchurl
, pkg-config, intltool
, glib, dbus, gtk3, libappindicator-gtk3, gst_all_1
, librsvg, wrapGAppsHook
, pulseaudioSupport ? true, libpulseaudio }:

stdenv.mkDerivation rec {
  pname = "audio-recorder";
  version = "2.1.3";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "${meta.homepage}/+archive/ubuntu/ppa/+files/audio-recorder_${version}%7Ebionic.tar.gz";
    sha256 = "160pnmnmc9zwzyclsci3w1qwlgxkfx1y3x5ck6i587w78570an1r";
  };

  # https://bugs.launchpad.net/audio-recorder/+bug/1784622
  env.NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ pkg-config intltool wrapGAppsHook ];

  buildInputs = [
    glib dbus gtk3 librsvg libappindicator-gtk3
  ] ++ (with gst_all_1; [
    gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
  ]) ++ lib.optional pulseaudioSupport libpulseaudio;

  meta = with lib; {
    description = "Audio recorder for GNOME and Unity Desktops";
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
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.msteen ];
  };
}

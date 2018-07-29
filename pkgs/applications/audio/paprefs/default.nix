{ fetchurl, stdenv, meson, ninja, gettext, pkgconfig, pulseaudioFull, gtkmm3, dbus-glib, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "paprefs-1.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/paprefs/${name}.tar.xz";
    sha256 = "0y77i9gaaassvvjrpwb4xbgqcmr51zmj5rh4z8zm687i5izf84md";
  };

  nativeBuildInputs = [ meson ninja gettext pkgconfig wrapGAppsHook ];

  buildInputs = [ pulseaudioFull gtkmm3 dbus-glib ];

  meta = with stdenv.lib; {
    description = "PulseAudio Preferences";

    longDescription = ''
      PulseAudio Preferences (paprefs) is a simple GTK based configuration
      dialog for the PulseAudio sound server.
    '';

    homepage = http://freedesktop.org/software/pulseaudio/paprefs/;

    license = licenses.gpl2Plus;

    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}

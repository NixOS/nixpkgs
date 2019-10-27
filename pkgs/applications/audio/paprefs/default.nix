{ fetchurl
, stdenv
, meson
, ninja
, gettext
, pkgconfig
, pulseaudioFull
, glibmm
, gtkmm3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "paprefs-1.1";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/paprefs/${name}.tar.xz";
    sha256 = "189z5p20hk0xv9vwvym293503j4pwl03xqk9hl7cl6dwgv0l7wkf";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkgconfig
    wrapGAppsHook
  ];

  buildInputs = [
    pulseaudioFull
    glibmm
    gtkmm3
  ];

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

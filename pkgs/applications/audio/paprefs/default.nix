{ fetchurl
, lib
, stdenv
, meson
, ninja
, gettext
, pkg-config
, pulseaudioFull
, glibmm
, gtkmm3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "paprefs";
  version = "1.1";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/paprefs/paprefs-${version}.tar.xz";
    sha256 = "189z5p20hk0xv9vwvym293503j4pwl03xqk9hl7cl6dwgv0l7wkf";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    pulseaudioFull
    glibmm
    gtkmm3
  ];

  meta = with lib; {
    description = "PulseAudio Preferences";

    longDescription = ''
      PulseAudio Preferences (paprefs) is a simple GTK based configuration
      dialog for the PulseAudio sound server.
    '';

    homepage = "http://freedesktop.org/software/pulseaudio/paprefs/";

    license = licenses.gpl2Plus;

    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}

{ fetchurl, stdenv, pkgconfig, pulseaudio, gtkmm, libsigcxx
, libglademm, libcanberra, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "pavucontrol-1.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/pavucontrol/${name}.tar.xz";
    sha256 = "1plcyrc7p6gqxjhxx2xh6162bkb29wixjrqrjnl9b8g3nrjjigix";
  };

  buildInputs = [ pkgconfig pulseaudio gtkmm libsigcxx libglademm libcanberra
    intltool gettext ];

  configureFlags = "--disable-lynx --disable-gtk3";

  meta = {
    description = "PulseAudio Volume Control";

    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK+
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';

    homepage = http://0pointer.de/lennart/projects/pavucontrol/;

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}

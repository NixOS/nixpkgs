{ fetchurl, stdenv, pkgconfig, pulseaudio, gtkmm, libsigcxx
, libglademm, libcanberra, intltool, gettext }:

stdenv.mkDerivation rec {
  name = "pavucontrol-0.9.10";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/pavucontrol/${name}.tar.gz";
    sha256 = "0g2sd9smwwpnyq8yc65dl9z0iafj2rrimi8v58wkxx98vhnnvsby";
  };

  buildInputs = [ pkgconfig pulseaudio gtkmm libsigcxx libglademm libcanberra
    intltool gettext ];

  configureFlags = "--disable-lynx";

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

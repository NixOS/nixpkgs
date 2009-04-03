{ fetchurl, stdenv, pkgconfig, pulseaudio, gtkmm, libsigcxx
, libglademm, libcanberra, gettext }:

stdenv.mkDerivation rec {
  name = "pavucontrol-0.9.7";

  src = fetchurl {
    url = "http://0pointer.de/lennart/projects/pavucontrol/${name}.tar.gz";
    sha256 = "1a1v06hbl1j78ryqy5aiccg6w5hf1yzday2b9h31kx7vr42ir1w0";
  };

  buildInputs = [ pkgconfig pulseaudio gtkmm libsigcxx libglademm libcanberra gettext ];

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
  };
}

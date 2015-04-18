{ fetchurl, stdenv, pkgconfig, intltool, pulseaudio, gtkmm3
, libcanberra_gtk3, makeWrapper, gnome3 }:

stdenv.mkDerivation rec {
  name = "pavucontrol-3.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/pavucontrol/${name}.tar.xz";
    sha256 = "14486c6lmmirkhscbfygz114f6yzf97h35n3h3pdr27w4mdfmlmk";
  };

  preFixup = ''
    wrapProgram "$out/bin/pavucontrol" \
     --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
  '';

  buildInputs = [ pulseaudio gtkmm3 libcanberra_gtk3 makeWrapper
                  gnome3.gnome_icon_theme ];

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ "--disable-lynx" ];

  meta = with stdenv.lib; {
    description = "PulseAudio Volume Control";

    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK+
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';

    homepage = http://freedesktop.org/software/pulseaudio/pavucontrol/ ;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ maintainers.abbradar ];
    platforms = platforms.linux;
  };
}

{ fetchurl, stdenv, pkgconfig, intltool, pulseaudio, gtkmm3
, libcanberra_gtk3, makeWrapper, gnome3 }:

stdenv.mkDerivation rec {
  name = "pavucontrol-2.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/pavucontrol/${name}.tar.xz";
    sha256 = "02s775m1531sshwlbvfddk3pz8zjmwkv1sgzggn386ja3gc9vwi2";
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

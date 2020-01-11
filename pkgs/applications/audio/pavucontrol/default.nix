{ fetchurl, stdenv, pkgconfig, intltool, libpulseaudio, gtkmm3
, libcanberra-gtk3, makeWrapper, gnome3 }:

stdenv.mkDerivation rec {
  pname = "pavucontrol";
  version = "4.0";

  src = fetchurl {
    url = "https://freedesktop.org/software/pulseaudio/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1qhlkl3g8d7h72xjskii3g1l7la2cavwp69909pzmbi2jyn5pi4g";
  };

  preFixup = ''
    wrapProgram "$out/bin/pavucontrol" \
     --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
     --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
  '';

  buildInputs = [ libpulseaudio gtkmm3 libcanberra-gtk3 makeWrapper
                  gnome3.adwaita-icon-theme ];

  nativeBuildInputs = [ pkgconfig intltool ];

  configureFlags = [ "--disable-lynx" ];

  meta = with stdenv.lib; {
    description = "PulseAudio Volume Control";

    longDescription = ''
      PulseAudio Volume Control (pavucontrol) provides a GTK
      graphical user interface to connect to a PulseAudio server and
      easily control the volume of all clients, sinks, etc.
    '';

    homepage = http://freedesktop.org/software/pulseaudio/pavucontrol/;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = with maintainers; [ abbradar globin ];
    platforms = platforms.linux;
  };
}

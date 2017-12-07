{ fetchurl, stdenv, pkgconfig, libpulseaudio, gtkmm2, libglademm
, dbus_glib, GConf, gconfmm, intltool }:

stdenv.mkDerivation rec {
  name = "paprefs-0.9.10";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/paprefs/${name}.tar.xz";
    sha256 = "1c5b3sb881szavly220q31g7rvpn94wr7ywlk00hqb9zaikml716";
  };

  buildInputs = [ libpulseaudio gtkmm2 libglademm dbus_glib gconfmm ];

  nativeBuildInputs = [ pkgconfig intltool ];

  propagatedUserEnvPkgs = [ GConf ];

  configureFlags = [ "--disable-lynx" ];

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

{ stdenv, fetchurl, pkgconfig, glib, libwnck3, libnotify, dbus_glib, makeWrapper, gnome3 }:

stdenv.mkDerivation rec {
  name = "notify-osd-${version}";
  version = "0.9.34";

  src = fetchurl {
    url = "https://launchpad.net/notify-osd/precise/${version}/+download/notify-osd-${version}.tar.gz";
    sha256 = "0g5a7a680b05x27apz0y1ldl5csxpp152wqi42s107jymbp0s20j";
  };

  buildInputs = [
    pkgconfig glib libwnck3 libnotify dbus_glib makeWrapper
    gnome3.gsettings_desktop_schemas
  ];

  configureFlags = "--libexecdir=$(out)/bin";

  preFixup = ''
    wrapProgram "$out/bin/notify-osd" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Daemon that displays passive pop-up notifications";
    homepage = https://launchpad.net/notify-osd;
    license = licenses.gpl3;
    maintainers = [ maintainers.bodil ];
    platforms = platforms.linux;
  };
}

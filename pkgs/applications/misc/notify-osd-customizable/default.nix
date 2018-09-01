{ stdenv
, dbus-glib
, fetchurl
, glib
, gnome3
, libnotify
, libtool
, libwnck3
, makeWrapper
, pkgconfig
}:

let baseURI = "https://launchpad.net/~leolik/+archive/leolik";
in stdenv.mkDerivation rec {
  name = "notify-osd-${version}";
  version = "0.9.35+16.04.20160415";

  src = fetchurl {
    url = "${baseURI}/+files/notify-osd_${version}-0ubuntu1-leolik~ppa0.tar.gz";
    sha256 = "026dr46jh3xc4103wnslzy7pxbxkkpflh52c59j8vzwaa7bvvzkv";
    name = "notify-osd-customizable.tar.gz";
  };

  preConfigure = "./autogen.sh --libexecdir=$(out)/bin";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    glib libwnck3 libnotify dbus-glib makeWrapper
    gnome3.gsettings-desktop-schemas gnome3.gnome-common
    libtool
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
    maintainers = [ maintainers.imalison ];
    platforms = platforms.linux;
  };
}

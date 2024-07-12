{ lib, stdenv
, dbus-glib
, fetchurl
, glib
, gnome-common
, libnotify
, libtool
, libwnck
, makeWrapper
, pkg-config
, gsettings-desktop-schemas
}:

let baseURI = "https://launchpad.net/~leolik/+archive/leolik";
in stdenv.mkDerivation rec {
  pname = "notify-osd";
  version = "0.9.35+16.04.20160415";

  src = fetchurl {
    url = "${baseURI}/+files/notify-osd_${version}-0ubuntu1-leolik~ppa0.tar.gz";
    sha256 = "026dr46jh3xc4103wnslzy7pxbxkkpflh52c59j8vzwaa7bvvzkv";
    name = "notify-osd-customizable.tar.gz";
  };

  preConfigure = "./autogen.sh --libexecdir=$(out)/bin";

  nativeBuildInputs = [ pkg-config makeWrapper libtool ];
  buildInputs = [
    glib libwnck libnotify dbus-glib
    gsettings-desktop-schemas gnome-common
  ];

  configureFlags = [ "--libexecdir=$(out)/bin" ];

  preFixup = ''
    wrapProgram "$out/bin/notify-osd" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with lib; {
    description = "Daemon that displays passive pop-up notifications";
    mainProgram = "notify-osd";
    homepage = "https://launchpad.net/notify-osd";
    license = licenses.gpl3;
    maintainers = [ maintainers.imalison ];
    platforms = platforms.linux;
  };
}

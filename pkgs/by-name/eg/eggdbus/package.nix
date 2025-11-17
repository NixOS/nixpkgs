{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  dbus,
  dbus-glib,
}:

stdenv.mkDerivation rec {
  pname = "eggdbus";
  version = "0.6";

  src = fetchurl {
    url = "https://hal.freedesktop.org/releases/${pname}-${version}.tar.gz";
    sha256 = "118hj63ac65zlg71kydv4607qcg1qpdlql4kvhnwnnhar421jnq4";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glib
    dbus
    dbus-glib
  ];

  meta = with lib; {
    homepage = "https://hal.freedesktop.org/releases/";
    description = "D-Bus bindings for GObject";
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}

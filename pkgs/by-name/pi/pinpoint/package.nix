{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  autoconf,
  automake,
  clutter,
  clutter-gst,
  gdk-pixbuf,
  cairo,
  clutter-gtk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinpoint";
  version = "0.1.8";
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pinpoint/0.1/pinpoint-${finalAttrs.version}.tar.xz";
    sha256 = "1jp8chr9vjlpb5lybwp5cg6g90ak5jdzz9baiqkbg0anlg8ps82s";
  };
  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    clutter
    clutter-gst
    gdk-pixbuf
    cairo
    clutter-gtk
  ];

  meta = {
    homepage = "https://gitlab.gnome.org/Archive/pinpoint";
    description = "Tool for making hackers do excellent presentations";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pSub ];
    mainProgram = "pinpoint";
  };
})

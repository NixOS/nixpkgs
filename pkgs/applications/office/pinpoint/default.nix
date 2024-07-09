{ fetchurl, lib, stdenv, pkg-config, autoconf, automake, clutter, clutter-gst
, gdk-pixbuf, cairo, clutter-gtk }:

stdenv.mkDerivation rec {
  pname = "pinpoint";
  version = "0.1.8";
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pinpoint/0.1/${pname}-${version}.tar.xz";
    sha256 = "1jp8chr9vjlpb5lybwp5cg6g90ak5jdzz9baiqkbg0anlg8ps82s";
  };
  nativeBuildInputs = [ pkg-config autoconf automake ];
  buildInputs = [ clutter clutter-gst gdk-pixbuf
                  cairo clutter-gtk ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/Archive/pinpoint";
    description = "Tool for making hackers do excellent presentations";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "pinpoint";
  };
}

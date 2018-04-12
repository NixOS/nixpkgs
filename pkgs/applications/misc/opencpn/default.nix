{ stdenv, fetchFromGitHub, pkgconfig, cmake, wxGTK_2, libpulseaudio, curl,
  gettext, glib, portaudio }:

stdenv.mkDerivation rec {
  name = "opencpn-${version}";
  version = "4.8.2";

  src = fetchFromGitHub {
    owner = "OpenCPN";
    repo = "OpenCPN";
    rev = "v${version}";
    sha256 = "0r6a279xhhf4jrmjb2xi5arxb4xd5wvqbs4hyyildlgpr1x7bd09";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake wxGTK_2 wxGTK_2.gtk libpulseaudio curl gettext glib portaudio ];

  cmakeFlags = [
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${wxGTK_2.gtk.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A concise ChartPlotter/Navigator";
    maintainers = [ stdenv.lib.maintainers.kragniz ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    homepage = https://opencpn.org/;
  };
}

{ stdenv, fetchFromGitHub, pkgconfig, cmake, gtk2, wxGTK30, libpulseaudio, curl,
  gettext, glib, portaudio }:

stdenv.mkDerivation rec {
  pname = "opencpn-unstable";
  version = "2019-05-15";

  src = fetchFromGitHub {
    owner = "OpenCPN";
    repo = "OpenCPN";
    rev = "83a3c4b5ff011d4eb070f009e0a46d194b177047";
    sha256 = "00s1mxnkf1gg41hrz0zp8ypkp98py0m1c22im2zd09k6lcddxw5p";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake gtk2 wxGTK30 libpulseaudio curl gettext
                  glib portaudio ];

  cmakeFlags = [
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A concise ChartPlotter/Navigator";
    maintainers = [ stdenv.lib.maintainers.kragniz ];
    platforms = [ "x86_64-linux" ];
    license = stdenv.lib.licenses.gpl2;
    homepage = https://opencpn.org/;
  };
}

{ stdenv, fetchFromGitHub, pkgconfig, cmake, gtk2, wxGTK30, libpulseaudio, curl,
  gettext, glib, portaudio }:

stdenv.mkDerivation rec {
  pname = "opencpn-unstable";
  version = "2019-11-21";

  src = fetchFromGitHub {
    owner = "OpenCPN";
    repo = "OpenCPN";
    rev = "e73dc935545b2bbcf193cc61d987a0178c52d7a7";
    sha256 = "0yiqahkzwcbzgabc5xgxmwlngapkfiaqyva3mwz29xj0c5lg2bdk";
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

{ mkDerivation, lib, cmake, xorg, plasma-framework, fetchurl
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, kcrash, knewstuff }:

mkDerivation rec {
  pname = "latte-dock";
  version = "0.8.9";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1kkpxa39crjpqgamrcpgp1mrcdg0aq9850yb6cf7lw7d3x2fdrxj";
    name = "${pname}-${version}.tar.xz";
  };

  buildInputs = [ plasma-framework xorg.libpthreadstubs xorg.libXdmcp xorg.libSM ];

  nativeBuildInputs = [ extra-cmake-modules cmake karchive kwindowsystem
    qtx11extras kcrash knewstuff ];



  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = https://github.com/psifidotos/Latte-Dock;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.benley maintainers.ysndr ];
  };


}

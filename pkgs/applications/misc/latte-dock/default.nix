{ mkDerivation, lib, cmake, xorg, plasma-framework, fetchurl
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, kcrash, knewstuff }:

mkDerivation rec {
  pname = "latte-dock";
  version = "0.8.6";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${name}.tar.xz";
    sha256 = "1qzf9fkfkbv8vnc9p6lm7ya9hzydwk2f7671by9ij26f77lmxfb3";
    name = "${name}.tar.xz";
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

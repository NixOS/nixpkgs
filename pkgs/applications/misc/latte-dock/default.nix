{ mkDerivation, lib, cmake, xorg, plasma-framework, fetchurl
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, kcrash, knewstuff }:

mkDerivation rec {
  pname = "latte-dock";
  version = "0.10.0";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "04kq86qmrjbzidrkknj000pv1b5z0r7nfidhy2zv67ks8fdi4zln";
    name = "${pname}-${version}.tar.xz";
  };

  buildInputs = [ plasma-framework xorg.libpthreadstubs xorg.libXdmcp xorg.libSM ];

  nativeBuildInputs = [ extra-cmake-modules cmake karchive kwindowsystem
    qtx11extras kcrash knewstuff ];

  patches = [
    ./0001-close-user-autostart.patch
  ];
  fixupPhase = ''
    mkdir -p $out/etc/xdg/autostart
    cp $out/share/applications/org.kde.latte-dock.desktop $out/etc/xdg/autostart
  '';

  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = "https://github.com/psifidotos/Latte-Dock";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.benley maintainers.ysndr ];
  };


}

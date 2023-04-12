{ mkDerivation, lib, cmake, xorg, plasma-framework, plasma-wayland-protocols, fetchFromGitLab
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, qtwayland, kcrash, knewstuff
, wayland, plasma-workspace }:

mkDerivation rec {
  pname = "latte-dock";
  version = "unstable-2023-03-31";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "latte-dock";
    rev = "4f93251d8c635c6150483ecb321eb276f34d4280";
    sha256 = "sha256-oEfKfsVIAmYgQ7+WyBEQfVpI4IndWhYXWBsJE8bNNyI=";
  };

  buildInputs = [ plasma-framework plasma-wayland-protocols qtwayland xorg.libpthreadstubs xorg.libXdmcp xorg.libSM wayland plasma-workspace ];

  nativeBuildInputs = [ extra-cmake-modules cmake karchive kwindowsystem
    qtx11extras kcrash knewstuff ];

  patches = [
    ./0001-Disable-autostart.patch
  ];

  postInstall = ''
    mkdir -p $out/etc/xdg/autostart
    cp $out/share/applications/org.kde.latte-dock.desktop $out/etc/xdg/autostart
  '';

  meta = with lib; {
    description = "Dock-style app launcher based on Plasma frameworks";
    homepage = "https://invent.kde.org/plasma/latte-dock";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.ysndr ];
  };


}

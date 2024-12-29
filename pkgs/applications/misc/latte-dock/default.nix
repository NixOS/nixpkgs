{ mkDerivation, lib, cmake, xorg, plasma-framework, plasma-wayland-protocols, fetchFromGitLab
, extra-cmake-modules, karchive, kwindowsystem, qtx11extras, qtwayland, kcrash, knewstuff
, wayland, plasma-workspace, plasma-desktop }:

mkDerivation rec {
  pname = "latte-dock";
  version = "unstable-2024-01-31";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "plasma";
    repo = "latte-dock";
    rev = "131ee4d39ce8913b2de8f9a673903225345c7a38";
    sha256 = "sha256-C1FvgkdxCzny+F6igS2YjsHOpkK34wl6je2tHlGQwU0=";
  };

  buildInputs = [ plasma-framework plasma-wayland-protocols qtwayland xorg.libpthreadstubs xorg.libXdmcp xorg.libSM wayland plasma-workspace plasma-desktop ];

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
    mainProgram = "latte-dock";
    homepage = "https://invent.kde.org/plasma/latte-dock";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.ysndr ];
  };


}

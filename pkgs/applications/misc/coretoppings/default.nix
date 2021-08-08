{ mkDerivation, lib, fetchFromGitLab, libcprime, cmake, ninja
, ffmpeg, qtbase, qtx11extras, qtconnectivity, v4l-utils, grim, wf-recorder
, libdbusmenu, playerctl, xorg, iio-sensor-proxy, inotify-tools
, bluez, networkmanager, connman, redshift, gawk
, polkit, libnotify, systemd, xdg-utils }:

mkDerivation rec {
  pname = "coretoppings";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DpmzGqjW1swLirRLzd5nblAb40LHAmf8nL+VykQNL3E=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  patches = [
    # Fix file cannot create directory: /var/empty/share/polkit-1/actions
    ./0001-fix-install-phase.patch
  ];

  buildInputs = [
    qtbase
    qtx11extras
    qtconnectivity
    libdbusmenu
    libcprime
    ffmpeg
    v4l-utils
    grim
    wf-recorder
    playerctl
    xorg.xrandr
    xorg.xinput
    xorg.libXdamage
    iio-sensor-proxy
    inotify-tools
    bluez
    networkmanager
    connman
    redshift
    gawk
    polkit
    libnotify
    systemd
    xdg-utils
  ];

  meta = with lib; {
    description = "Additional features,plugins etc for CuboCore Application Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coretoppings";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}

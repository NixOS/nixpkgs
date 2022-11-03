{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, pkg-config
, qtbase
, qtwebengine
, knotifications
, kxmlgui
, kglobalaccel
, pipewire
, xdg-desktop-portal
}:

stdenv.mkDerivation rec {
  pname = "discord-screenaudio";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "maltejur";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PPP/+7x0dcQHowB7hUZu85LK/G+ohrPeRB0vv6e3PBg=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DPipeWire_INCLUDE_DIRS=${pipewire.dev}/include/pipewire-0.3"
    "-DSpa_INCLUDE_DIRS=${pipewire.dev}/include/spa-0.2"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwebengine
    knotifications
    kxmlgui
    kglobalaccel
    pipewire
    pipewire.pulse
    xdg-desktop-portal
  ];

  meta = with lib; {
    homepage = "https://github.com/maltejur/discord-screenaudio";
    description = "A custom discord client that supports streaming with audio on Linux";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ michaelBelsanti ];
  };
}

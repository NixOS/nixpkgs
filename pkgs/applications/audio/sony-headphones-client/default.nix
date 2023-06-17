{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, bluez, dbus, glew, glfw, imgui, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "SonyHeadphonesClient";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Plutoberth";
    repo = "SonyHeadphonesClient";
    rev = "v${version}";
    hash = "sha256-vhI97KheKzr87exCh4xNN7NDefcagdMu1tWSt67vLiU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config copyDesktopItems ];
  buildInputs = [ bluez dbus glew glfw imgui ];

  sourceRoot = "./source/Client";

  cmakeFlags = [ "-Wno-dev" ];

  postPatch = ''
    substituteInPlace Constants.h \
      --replace "UNKNOWN = -1" "// UNKNOWN removed since it doesn't fit in char"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin SonyHeadphonesClient
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "SonyHeadphonesClient";
      exec = "SonyHeadphonesClient";
      icon = "SonyHeadphonesClient";
      desktopName = "Sony Headphones Client";
      comment = "A client recreating the functionality of the Sony Headphones app";
      categories = [ "Audio" "Mixer" ];
    })
  ];

  meta = with lib; {
    description = "A client recreating the functionality of the Sony Headphones app";
    homepage = "https://github.com/Plutoberth/SonyHeadphonesClient";
    license = licenses.mit;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
}

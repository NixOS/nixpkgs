{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, bluez, dbus, glew, glfw, imgui, makeDesktopItem, copyDesktopItems }:

stdenv.mkDerivation rec {
  pname = "SonyHeadphonesClient";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Plutoberth";
    repo = "SonyHeadphonesClient";
    # rev = "v${version}";
    rev = "c8f60c030bfe1987415d05241a6839648d40b358"; # include aarch64 patch
    hash = "sha256-xRbPFaPlO5hyDQJyM4Pf56icRcJAL9H46Ep+hcl3DUg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config copyDesktopItems ];
  buildInputs = [ bluez dbus glew glfw imgui ];

  sourceRoot = "./source/Client";

  cmakeFlags = [ "-Wno-dev" ];

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
      categories = [ "Audio" "AudioVideo" "Mixer" ];
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

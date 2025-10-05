{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  bluez,
  dbus,
  glew,
  glfw,
  imgui,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "SonyHeadphonesClient";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Plutoberth";
    repo = "SonyHeadphonesClient";
    tag = "v${version}";
    hash = "sha256-vhI97KheKzr87exCh4xNN7NDefcagdMu1tWSt67vLiU=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      name = "include-cstdint-to-fix-gcc-compiling.patch";
      url = "https://github.com/Plutoberth/SonyHeadphonesClient/commit/4da8a12b22f8a45e79aa53d4cae88ca99b51d41f.patch";
      stripLen = 2;
      extraPrefix = "";
      hash = "sha256-IZR/Znj40pUEC9gmNJDMPWuZOM2ueAgykZFn5DVn6es=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
  ];
  buildInputs = [
    bluez
    dbus
    glew
    glfw
    imgui
  ];

  sourceRoot = "${src.name}/Client";

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
      categories = [
        "Audio"
        "Mixer"
      ];
    })
  ];

  meta = with lib; {
    description = "Client recreating the functionality of the Sony Headphones app";
    homepage = "https://github.com/Plutoberth/SonyHeadphonesClient";
    license = licenses.mit;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
    mainProgram = "SonyHeadphonesClient";
  };
}

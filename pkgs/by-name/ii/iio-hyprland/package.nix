{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  meson,
  cmake,
  pkg-config,
  dbus,
  ninja,
}:

stdenv.mkDerivation {
  pname = "iio-hyprland";
  version = "0-unstable-2026-09-07";

  src = fetchFromGitHub {
    owner = "JeanSchoeller";
    repo = "iio-hyprland";
    rev = "8f562190a057c0b2b18dc703041da1a4a447a2a6";
    hash = "sha256-RrknSGqeQH5vGnOnhoj13/tQ1AD07oz+xGMcvAnPkvc=";
  };

  buildInputs = [ dbus ];
  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Listens to iio-sensor-proxy and automatically changes Hyprland output orientation";
    homepage = "https://github.com/JeanSchoeller/iio-hyprland/tree/master";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yusuf-duran ];
    platforms = lib.platforms.linux;
    mainProgram = "iio-hyprland";
  };
}

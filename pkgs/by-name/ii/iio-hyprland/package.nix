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
  version = "0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "JeanSchoeller";
    repo = "iio-hyprland";
    rev = "f7ae269294bc812e966b9b60b89beefcdfd68821";
    hash = "sha256-tWMjZ5DktOIvgl45RRgaOF0x5Kj5gsKZG79LGNLyw58=";
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

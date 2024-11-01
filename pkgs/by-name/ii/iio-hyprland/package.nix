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
  version = "0-unstable-2024-09-29";

  src = fetchFromGitHub {
    owner = "JeanSchoeller";
    repo = "iio-hyprland";
    rev = "bd6be6b7e0fbc8ca1a5ccbf536602838e52c347e";
    hash = "sha256-gfH/jcrmI27OEge8OGPe7JpC0jrQJuX7v9hM/ObjjW8=";
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

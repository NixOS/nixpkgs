{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, wayland
, wayland-protocols
, hyprlang
, sdbus-cpp
, systemd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hypridle";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7Ft5WZTMIjXOGgRCf31DZBwK6RK8xkeKlD5vFXz3gII=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprlang
    sdbus-cpp
    systemd
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Hyprland's idle daemon";
    homepage = "https://github.com/hyprwm/hypridle";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iogamaster ];
    mainProgram = "hypridle";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
})

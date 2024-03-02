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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hypridle";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YayFU0PZkwnKn1RSV3+i2HlSha/IFkG5osXcT0b/EUw=";
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

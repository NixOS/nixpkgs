{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  hyprland,
  wayland,
  wayland-protocols,
  wayland-scanner,
  mesa,
  libGL,
}:

stdenv.mkDerivation rec {
  pname = "hyprlax";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "sandwichfarm";
    repo = "hyprlax";
    tag = "v${version}";
    hash = "sha256-NoXoYxrQREL8eTN7vdEDzkoUwJxw3c+ujmDAA4dXgiM=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    mesa
    libGL
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Smooth parallax wallpaper animations for Hyprland";
    homepage = "https://github.com/sandwichfarm/hyprlax";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.oncaged ];

    inherit (hyprland.meta) platforms;
  };
}

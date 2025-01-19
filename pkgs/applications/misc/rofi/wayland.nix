{
  lib,
  fetchFromGitHub,
  rofi-unwrapped,
  wayland-scanner,
  pkg-config,
  wayland-protocols,
  wayland,
}:

rofi-unwrapped.overrideAttrs (oldAttrs: rec {
  pname = "rofi-wayland-unwrapped";
  version = "1.7.7+wayland1";

  src = fetchFromGitHub {
    owner = "lbonn";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-wGBB7h2gZRQNmHV0NIbD0vvHtKZqnT5hd2gz5smKGoU=";
  };

  depsBuildBuild = oldAttrs.depsBuildBuild ++ [ pkg-config ];
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
    wayland-protocols
    wayland-scanner
  ];
  buildInputs = oldAttrs.buildInputs ++ [
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Window switcher, run dialog and dmenu replacement for Wayland";
    homepage = "https://github.com/lbonn/rofi";
    license = lib.licenses.mit;
    mainProgram = "rofi";
    maintainers = with lib.maintainers; [ bew ];
    platforms = with lib.platforms; linux;
  };
})

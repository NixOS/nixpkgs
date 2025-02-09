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
  version = "1.7.8+wayland1";

  src = fetchFromGitHub {
    owner = "lbonn";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-6hQfy0c73z1Oi2mGjuhKLZQIBpG1u06v40dmlc5fL/w=";
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

  meta = with lib; {
    description = "Window switcher, run dialog and dmenu replacement for Wayland";
    homepage = "https://github.com/lbonn/rofi";
    license = licenses.mit;
    mainProgram = "rofi";
    maintainers = with maintainers; [ bew ];
    platforms = with platforms; linux;
  };
})

{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rofi-unwrapped,
  wayland-scanner,
  pkg-config,
  wayland-protocols,
  wayland,
}:

rofi-unwrapped.overrideAttrs (oldAttrs: rec {
  pname = "rofi-wayland-unwrapped";
  version = "1.7.5+wayland3";

  src = fetchFromGitHub {
    owner = "lbonn";
    repo = "rofi";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-pKxraG3fhBh53m+bLPzCigRr6dBcH/A9vbdf67CO2d8=";
  };

  patches = [
    # Fix use on niri window manager
    # ref. https://github.com/davatorium/rofi/discussions/2008
    # this was merged upstream, and can be removed on next release
    (fetchpatch {
      url = "https://github.com/lbonn/rofi/commit/55425f72ff913eb72f5ba5f5d422b905d87577d0.patch";
      hash = "sha256-vTUxtJs4SuyPk0PgnGlDIe/GVm/w1qZirEhKdBp4bHI=";
    })
  ];

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

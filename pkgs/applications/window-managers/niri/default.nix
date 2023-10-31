{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, pipewire
, seatd
, udev
, wayland
, libinput
, mesa
}:

rustPlatform.buildRustPackage rec {
  pname = "niri";
  version = "unstable-2023-10-31";

  src = fetchFromGitHub {
    owner = "YaLTeR";
    repo = "niri";
    rev = "d854c2d699b15c68c4715dc6be803065c01f2fe6";
    hash = "sha256-QYH3sG1TKJbKBeZdI9FtmJuY5DFmMdOJviYPrPK8FHo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-0.3.0" = "sha256-cRBJ8r2fQ8d97DADOxfmUF5JYcOHQ05u8tMhVXmbrbE=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
    pipewire
    seatd
    udev
    wayland
    libinput
    mesa # libgbm
  ];

  meta = with lib; {
    description = "A scrollable-tiling Wayland compositor";
    homepage = "https://github.com/YaLTeR/niri";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "niri";
    inherit (wayland.meta) platforms;
  };
}

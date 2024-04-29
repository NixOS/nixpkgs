{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-activewindow";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = "hyprland-activewindow";
    rev = "v${version}";
    hash = "sha256-kF2dNb9hiC6RcL2XG8k18da5he94Jpv3v+HdfHbeW3E=";
  };

  cargoHash = "sha256-YCzAfVLKDECGG/1fs3vyVB0oglxLFSE+2cnmLc7RoEo=";

  meta = with lib; {
    description = "A multi-monitor-aware Hyprland workspace widget helper";
    homepage = "https://github.com/FieldofClay/hyprland-activewindow";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kiike donovanglover ];
    mainProgram = "hyprland-activewindow";
  };
}

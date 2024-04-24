{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "hyprland-activewindow";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "FieldOfClay";
    repo = "hyprland-activewindow";
    rev = "v${version}";
    hash = "sha256-8pzm8uIyvlz4nHbxtmbMblFIj38M2VsenaKzJ9di1Do=";
  };

  cargoHash = "sha256-wIF0qa1dyZlcsLPL2TflFQFPm4Pe9TWHe1F2L1YccZ8=";

  meta = with lib; {
    description = "A multi-monitor-aware Hyprland workspace widget helper";
    homepage = "https://github.com/FieldofClay/hyprland-activewindow";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kiike donovanglover ];
    mainProgram = "hyprland-activewindow";
  };
}

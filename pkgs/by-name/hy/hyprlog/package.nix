{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyprlog";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gusjengis";
    repo = "hyprlog";
    rev = "v${version}";
    hash = "sha256-GQ/vF5Ebp3l2C6GgCqSFMK25xHTgJINByqV8ksm/Vl0=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  meta = with lib; {
    description = "Hyprland focus/activity logger";
    homepage = "https://github.com/gusjengis/hyprlog";
    license = licenses.mit;
    maintainers = [ maintainers.gusjengis ];
    mainProgram = "hyprlog";
    platforms = platforms.linux;
  };
}

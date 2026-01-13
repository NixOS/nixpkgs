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
    hash = "sha256-bvsJGBQd9TRSBJtvai4uHnRGtciN19BL2xnUMBqh5pg=";
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

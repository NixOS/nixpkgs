{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  pango,
}:

rustPlatform.buildRustPackage rec {
  pname = "i3bar-river";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "MaxVerevkin";
    repo = "i3bar-river";
    rev = "v${version}";
    hash = "sha256-nUS53qL0CM4MJNomsAwINee3Yv1f7jqUg8S3ecusFB8=";
  };

  cargoHash = "sha256-QniAkaVvr7kaBJAgiL+k6im99m9ZNZVpZGlHgSkZZtw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pango ];

  meta = with lib; {
    description = "Port of i3bar for river";
    homepage = "https://github.com/MaxVerevkin/i3bar-river";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nicegamer7 ];
    mainProgram = "i3bar-river";
    platforms = platforms.linux;
  };
}

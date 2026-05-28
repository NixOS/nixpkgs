{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wayland
,
}:
rustPlatform.buildRustPackage rec {
  pname = "gharial";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "gusahlg";
    repo = "gharial";
    rev = "v${version}";
    hash = "sha256-Xlu4KxN4jo7msCWFXE7iQCMipe7XTsQRNkP7bDPfzVo=";
  };

  cargoHash = "sha256-Fqhgdqs7xXmd6Bpg7kYLWLiu+Yn4JTbMtJo4iLLFcIs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
  ];

  meta = {
    description = "Minimal external window manager for the river Wayland compositor";
    homepage = "https://github.com/gusahlg/gharial";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gusahlg ];
    mainProgram = "gharial";
    platforms = lib.platforms.linux;
  };
}


{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  xorg,
}:

rustPlatform.buildRustPackage rec {
  pname = "flitter";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "alexozer";
    repo = "flitter";
    tag = version;
    hash = "sha256-2oK70WusLzLh2Pnb80S2rbpd7IFdApvIVvdYuhvkfBs=";
  };

  cargoHash = "sha256-UiHy4k4yLgwLZrnR07It93gM3dShou9OD055yygWN24=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
  ];

  meta = with lib; {
    description = "Livesplit-inspired speedrunning split timer for Linux/macOS terminal";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
    homepage = "https://github.com/alexozer/flitter";
    platforms = platforms.unix;
    mainProgram = "flitter";
    broken = stdenv.hostPlatform.isDarwin;
  };
}

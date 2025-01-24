{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rwpspread";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${version}";
    hash = "sha256-ivxu1UsQLUm017A5Za82+l1bQoYA/TF/I1BwUQD3dWo=";
  };
  cargoHash = "sha256-pIsSH8cQYyG7v7z4O2R80kA4QHvKyTajBfqmRXjuQW8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxkbcommon ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-Monitor Wallpaper Utility";
    homepage = "https://github.com/0xk1f0/rwpspread";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fsnkty ];
    platforms = lib.platforms.linux;
    mainProgram = "rwpspread";
  };
}

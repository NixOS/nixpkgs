{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rwpspread";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${version}";
    hash = "sha256-6pYMKBm3f0kH+KD6yWy7/H/bg8v7hNm81KAKHp02HY8=";
  };
  cargoHash = "sha256-/SjSwjrqODx9imtVxmOCrG4KwhXymHokyQ8FSC1SOd8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxkbcommon ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-Monitor Wallpaper Utility";
    homepage = "https://github.com/0xk1f0/rwpspread";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nu-nu-ko ];
    platforms = lib.platforms.linux;
    mainProgram = "rwpspread";
  };
}

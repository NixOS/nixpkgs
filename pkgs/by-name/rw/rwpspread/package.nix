{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rwpspread";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${version}";
    hash = "sha256-ACYELJU7Y4Xv+abQ/Vgo3xaP+jbO43K/CBE2yuEddko=";
  };
  cargoHash = "sha256-ZNWDUOEhh36YjbGZpljyXsL0g7iW6GheLi2WxCj4w+s=";

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

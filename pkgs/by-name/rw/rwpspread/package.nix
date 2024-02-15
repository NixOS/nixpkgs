{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rwpspread";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${version}";
    hash = "sha256-oZgHMklHMKUpVY3g7wS2rna+5+ePEbcvdVJc9jPTeoI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "smithay-client-toolkit-0.18.0" = "sha256-7s5XPmIflUw2qrKRAZUz30cybYKvzD5Hu4ViDpzGC3s=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxkbcommon
  ];

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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rwpspread";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lp9XvILpvNZtffJLyDUCo5Xyor4X4bwsfxAIqS8Hf7M=";
  };

  cargoHash = "sha256-aGy29kGwCKHBNzszYR+w+1m8gZ/lFd0MOlFHtDDzjj4=";

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
})

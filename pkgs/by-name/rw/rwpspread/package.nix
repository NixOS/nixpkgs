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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${version}";
    hash = "sha256-1i1675OiyleCXcc/uN95kyY7m5ht/rS3UKY7EmuSsrk=";
  };
  cargoHash = "sha256-5e/Fj/8wfWrl0b4WRDmX/BOBfeCrlN+mq3c0Qz7MQPE=";

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

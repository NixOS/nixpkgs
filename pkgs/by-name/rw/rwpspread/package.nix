{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libxkbcommon
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "rwpspread";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${version}";
    hash = "sha256-gtqcogOjWvie7XK9E9KhuSsUh+aWEqZB7NVTqXH6R7Q=";
  };
  cargoHash = "sha256-3yWc1wi5jakBG2CTWpB4uhqIzG0/ufQhyd61EtpibIk=";

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

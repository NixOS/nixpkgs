{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  expat,
  fontconfig,
  freetype,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "fontfor";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "7sDream";
    repo = "fontfor";
    rev = "v${version}";
    hash = "sha256-gJl9SPL/KeYFzKIjwWPVR1iVy6h/W7OP7xE7krhYaY8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
  ];

  cargoHash = "sha256-9Ac2NuUFfluXN4NOT645gszGApBIsFxQiTZDf8PHbvo=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Find fonts which can show a specified character and preview them in browser";
    homepage = "https://github.com/7sDream/fontfor";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
    mainProgram = "fontfor";
  };
}

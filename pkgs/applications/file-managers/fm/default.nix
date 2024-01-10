{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, libadwaita
, libpanel
, gtksourceview5
, poppler
}:

rustPlatform.buildRustPackage {
  pname = "fm";
  version = "unstable-2023-07-25";

  src = fetchFromGitHub {
    owner = "euclio";
    repo = "fm";
    rev = "a0830b5483a48a8b1e40982f20c28dcb5bfe4a6e";
    hash = "sha256-uso7j+bf6PF5wiTzSJymSxNNfzqXVcJygkfGdzQl4xA=";
  };

  cargoHash = "sha256-3IxpnDYbfLI1VAMgqIE4eSkiT9Z6HcC3K6MH6uqD9Ic=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libpanel
    gtksourceview5
    poppler
  ];

  meta = with lib; {
    description = "Small, general purpose file manager built with GTK4";
    homepage = "https://github.com/euclio/fm";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
    mainProgram = "fm";
    platforms = platforms.unix;
  };
}

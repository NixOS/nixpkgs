{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  libadwaita,
  libpanel,
  gtksourceview5,
  poppler,
}:

rustPlatform.buildRustPackage {
  pname = "fm";
  version = "0-unstable-2024-01-03";

  src = fetchFromGitHub {
    owner = "euclio";
    repo = "fm";
    rev = "f1da116fe703a2c3d5bc9450703ecf1a1f1b4fda";
    hash = "sha256-fCufqCy5H5Up6V15sOz8SJrixth7OQ7tc4yIymmfq1M=";
  };

  cargoHash = "sha256-E/mT+e17Qse4aPCY5Tuvih+ZMDnUqwvEBY0N70kciMs=";

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

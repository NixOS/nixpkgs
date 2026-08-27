{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk4
, gtk4-layer-shell
, wl-clipboard
, hyprland
}:

rustPlatform.buildRustPackage rec {
  pname = "file-preview-daemon";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "areofyl";
    repo = "file-preview-daemon";
    rev = "168aa36d9c4af7123d301ce6ee5b415f926c01e7";
    sha256 = "sha256-6VvD36dJhhza6vR9V8dUj+calZsHHhNgbUhFxd/7A4k=";
  };

  cargoHash = "sha256-cZiWksVePRYe5fEv+FspMDmp02qVRg2EOCkDY4MedSA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  propagatedBuildInputs = [
    wl-clipboard
    hyprland
  ];

  meta = with lib; {
    description = "File preview daemon for Waybar — shows new files and lets you drag-and-drop them";
    homepage = "https://github.com/areofyl/file-preview-daemon";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}

{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook3
, atk
, cairo
, gdk-pixbuf
, glib
, gtk3
, pango
, gtk-layer-shell
}:

rustPlatform.buildRustPackage rec {
  pname = "sway-easyfocus";
  version = "unstable-2023-11-05";

  src = fetchFromGitHub {
    owner = "edzdez";
    repo = "sway-easyfocus";
    rev = "4c70f6728dbfc859e60505f0a7fd82f5a90ed42c";
    hash = "sha256-WvYXhf13ZCoa+JAF4bYgi5mI22i9pZLtbIhF1odqaTU=";
  };

  cargoHash = "sha256-9cN0ervcU8JojwG7J250fprbCD2rB9kh9TbRU+wCE/Y=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    gtk-layer-shell
    pango
  ];

  meta = {
    description = "A tool to help efficiently focus windows in Sway, inspired by i3-easyfocus";
    homepage = "https://github.com/edzdez/sway-easyfocus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "sway-easyfocus";
  };
}

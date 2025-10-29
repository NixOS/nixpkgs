{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
  gtk-layer-shell,
}:

rustPlatform.buildRustPackage rec {
  pname = "sway-easyfocus";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "edzdez";
    repo = "sway-easyfocus";
    tag = version;
    hash = "sha256-ogqstgJqUczn0LDwpOAppC1J/Cs0IEOAXjNAnbiKn6M=";
  };

  cargoHash = "sha256-VxcMHh1eIiHugpTFpclwuO0joY95bPz6hVIBHQwB6ZA=";

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
    description = "Tool to help efficiently focus windows in Sway, inspired by i3-easyfocus";
    homepage = "https://github.com/edzdez/sway-easyfocus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pjones ];
    mainProgram = "sway-easyfocus";
  };
}

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
  version = "unstable-2025-01-14";

  src = fetchFromGitHub {
    owner = "edzdez";
    repo = "sway-easyfocus";
    rev = "4c1df53f630ac8791479eabfc9656b57de5e32e6";
    hash = "sha256-c3vDtettZuwopI/3ShIPIAokzYqPL9Q9hDXS6xmxm8c=";
  };

  cargoHash = "sha256-+7CRl3KPFJ6PMMb2kmby08SiF0KlUcHc8qZtoxrc0Po=";

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
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sway-easyfocus";
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  dbus,
  gdk-pixbuf,
  glib,
  gtk3,
  cairo,
  atk,
  pango,
  harfbuzz,
  gtk-layer-shell,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rumno";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "ivanmalison";
    repo = "rumno";
    rev = "v${version}";
    hash = "sha256-vR6+dNq0sdVtzdBL6GTzqAhl0fE6ulF6UCqIH1fSte4=";
  };

  cargoHash = "sha256-1FyDMdOO7m6y2oX/+VH5LxBwimz7fXM59eOeiffBnOI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    gdk-pixbuf
    glib
    gtk3
    cairo
    atk
    pango
    harfbuzz
    gtk-layer-shell
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visual pop-up notification manager";
    homepage = "https://gitlab.com/ivanmalison/rumno";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "rumno";
    platforms = lib.platforms.linux;
  };
}

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
  version = "0.1.2";

  src = fetchFromGitLab {
    owner = "ivanmalison";
    repo = "rumno";
    rev = "v${version}";
    hash = "sha256-uA7ny6m4g8+If7AGhSOonn97F/bJfW2NB9b8xIp5qaU=";
  };

  cargoHash = "sha256-o5KdjDxXfIQJkPsRgL13tcew53/iXKTNGrOVHA1prUA=";

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

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
  version = "0.1.1";

  src = fetchFromGitLab {
    owner = "ivanmalison";
    repo = "rumno";
    rev = "v${version}";
    hash = "sha256-rwbZonmwoiVSQ5zHxHeJfdd5fb1zTZ638E841P1IoEA=";
  };

  cargoHash = "sha256-9O96f1CtS8KAZu9S7FJmMWrZW7LfTAvfPqehzj/Y5jE=";

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

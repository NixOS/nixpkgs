{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
  glib,
  gtk4,
  libadwaita,
  libx11,
  libxtst,
  pkg-config,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage rec {
  pname = "lan-mouse";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "feschber";
    repo = "lan-mouse";
    rev = "v${version}";
    hash = "sha256-6EqA9WfiukOymUT4FkNdMvzmFKByW0LLoI/9sv4TzBU=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libx11
    libxtst
  ];

  cargoHash = "sha256-Lxs0qWvNAv4KCeJ+cDBYBzwlbJfQJshcxPRdg9w0szc=";

  postInstall = ''
    install -Dm444 de.feschber.LanMouse.desktop -t $out/share/applications
    install -Dm444 lan-mouse-gtk/resources/de.feschber.LanMouse.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  meta = {
    description = "Software KVM switch for sharing a mouse and keyboard with multiple hosts through the network";
    homepage = "https://github.com/feschber/lan-mouse";
    changelog = "https://github.com/feschber/lan-mouse/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "lan-mouse";
    maintainers = with lib.maintainers; [ pedrohlc ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}

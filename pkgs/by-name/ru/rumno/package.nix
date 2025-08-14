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
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "rumno";
  version = "0-unstable-2025-08-13";

  src = fetchFromGitLab {
    owner = "ivanmalison";
    repo = "rumno";
    rev = "a70bf6f05976b07ae5fdced2ab80d2b9e684fb92";
    hash = "sha256-reJIYlTR6fI42EcYGwb5BmEPVtls+s1+mFd7/34oXBw=";
  };

  cargoHash = "sha256-z9nGePcVc+RPSMPb7CAPOfUMoVlP1MKo57aVFkd1DmE=";

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

{ appstream
, blueprint-compiler
, desktop-file-utils
, fetchFromGitHub
, gettext
, glib
, gtk4
, lib
, libadwaita
, meson
, mesonEmulatorHook
, ninja
, pkg-config
, stdenv
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "raider";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ADBeveridge";
    repo = "raider";
    rev = "v${version}";
    hash = "sha256-zqM2B1M7E4CRupd09rvFYG7H7wBd2hTWnjN3xadS36w=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  meta = with lib; {
    description = "Permanently delete your files (also named File Shredder)";
    longDescription = ''
      Raider is a shredding program built for the GNOME
      desktop. It is meant to remove files from your
      computer permanently. Within a certain limit, it is
      effective. However, the way data is written physically
      to SSDs at the hardware level ensures that shredding
      is never perfect, and no software can fix that.
      However, top-level agencies are usually the only ones
      who can recover such data, due to the time, effort,
      money and patience required to extract it effectively.
    '';
    homepage = "https://apps.gnome.org/Raider";
    license = licenses.gpl3Plus;
    mainProgram = "raider";
    maintainers = with maintainers; [ benediktbroich aleksana ];
    platforms = platforms.unix;
  };
}

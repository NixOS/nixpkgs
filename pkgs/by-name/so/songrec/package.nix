{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gtk4,
  libadwaita,
  libsoup_3,
  glib-networking,
  alsa-lib,
  pkg-config,
  wrapGAppsHook4,
  ffmpeg,
  glib,
  libpulseaudio,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "songrec";
  version = "0.6.7";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "songrec";
    rev = finalAttrs.version;
    hash = "sha256-lCwFMBQ6IimNtXYMfTnFOpwOO2qbwijOEZ+oMsQKAP0=";
  };

  cargoHash = "sha256-BhDFGkvY6c8XbhJpFX1w8CSXK9IY/HiysNoooytFT9I=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    alsa-lib
    glib
    glib-networking
    gtk4
    libadwaita
    libpulseaudio
    libsoup_3
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ffmpeg ]}"
    )
  '';

  postInstall = ''
    mv packaging/rootfs/usr/share $out/share
  '';

  meta = {
    description = "Open-source Shazam client for Linux, written in Rust";
    homepage = "https://github.com/marin-m/SongRec";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tcbravo ];
    mainProgram = "songrec";
  };
})

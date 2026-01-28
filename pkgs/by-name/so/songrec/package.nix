{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gtk3,
  openssl,
  alsa-lib,
  pkg-config,
  ffmpeg,
  dbus,
  libpulseaudio,
}:

rustPlatform.buildRustPackage rec {
  pname = "songrec";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = "songrec";
    rev = version;
    hash = "sha256-i+uzC/zglKP0qBhUvmcF6+mCCUSxWpLiPxyIYpghI7s=";
  };

  cargoHash = "sha256-3l5jjnOsEJ575nbSSn6XPhO/EYwjHPgmbw7lpbULUHA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    dbus
    gtk3
    openssl
    ffmpeg
    libpulseaudio
  ];

  postInstall = ''
    mv packaging/rootfs/usr/share $out/share
  '';

  meta = {
    description = "Open-source Shazam client for Linux, written in Rust";
    homepage = "https://github.com/marin-m/SongRec";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tcbravo ];
    mainProgram = "songrec";
  };
}

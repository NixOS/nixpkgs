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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    hash = "sha256-pTonrxlYvfuLRKMXW0Lao4KCoNFlMzE9rH+hwpa60JY=";
  };

  cargoHash = "sha256-2BXUZD63xzHpUi8lk2fV5qBmeq6Gzpq0uEcKfbReANI=";

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

  meta = with lib; {
    description = "Open-source Shazam client for Linux, written in Rust";
    homepage = "https://github.com/marin-m/SongRec";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tcbravo ];
    mainProgram = "songrec";
  };
}

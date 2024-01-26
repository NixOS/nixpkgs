{ lib
, rustPlatform
, fetchFromGitHub
, gtk3
, openssl
, alsa-lib
, pkg-config
, ffmpeg
, dbus
, libpulseaudio
}:

rustPlatform.buildRustPackage rec {
  pname = "songrec";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    hash = "sha256-QgmeO6dE5d0X7iMjqvDz/i9tKEzGNzTYqZRXRgYepCg=";
  };

  cargoHash = "sha256-K6dkKtrHQVJfFo3yCWFb0zO4fJDunygU7hCnjAi4svc=";

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
    description = "An open-source Shazam client for Linux, written in Rust";
    homepage = "https://github.com/marin-m/SongRec";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tcbravo ];
  };
}

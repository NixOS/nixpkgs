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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    hash = "sha256-S44gtyz6L6uaLm3q75y8S4NJb77Vfy+Sd+J06IroHIM=";
  };

  cargoHash = "sha256-f2xAWh+y0Jw7QVLZBkajMLN3ocCyRsR480ai7+07LM4=";

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
    mainProgram = "songrec";
  };
}

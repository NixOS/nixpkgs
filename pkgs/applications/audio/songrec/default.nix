{ lib
, rustPlatform
, fetchFromGitHub
, gtk3
, openssl
, alsa-lib
, pkg-config
, ffmpeg
, dbus
}:

rustPlatform.buildRustPackage rec {
  pname = "songrec";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    sha256 = "sha256-aHZH3sQNUUPcMRySy8Di0XUoFo4qjGi2pi0phLwORaA=";
  };

  cargoSha256 = "sha256-EpkB43rMUJO6ouUV9TmQ+RSnGhX32DZHpKic1E6lUyU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib dbus gtk3 openssl ffmpeg ];

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

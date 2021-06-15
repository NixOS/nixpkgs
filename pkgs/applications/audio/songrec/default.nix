{ lib
, rustPlatform
, fetchFromGitHub
, gtk3
, openssl
, alsa-lib
, pkg-config
, ffmpeg
}:

rustPlatform.buildRustPackage rec {
  pname = "songrec";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    sha256 = "sha256-6siGLegNgvLdP7engwpKmhzWYqBXcMsfaXhJJ1tIqJg=";
  };

  cargoSha256 = "sha256-H4qJYcFjip71EVTGw50goj0HjKN9fmjQZqQDhaSKlaQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib gtk3 openssl ffmpeg ];

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

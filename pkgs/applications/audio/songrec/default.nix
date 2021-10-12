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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    sha256 = "sha256-9fq2P+F7Olm9bUQ1HbH/Lzb5J2mJCma+x/vuH3wf+zY=";
  };

  cargoSha256 = "sha256-ATlwBMuT8AufkrZNe1+U74hYRN4V88ZDKYvCWV52iyI=";

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

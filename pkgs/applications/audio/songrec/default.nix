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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    sha256 = "sha256-pKHKM4XOuuZCr4neMe1AVqWMuZghwYNe+ifJCQhXG/c=";
  };

  cargoSha256 = "sha256-J3ezXBOGJwzIPTHXujHpswsgh9PFy110AOQ2pPJNm10=";

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

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
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    hash = "sha256-K80uoMfwkyH/K8t6zdkq1ZYTpI0dAIvO2K2kzpzDoN0=";
  };

  cargoHash = "sha256-Xmey+goHGTWMgKIJRzKMi9Y1bv677Yo2sfDaMauvZsM=";

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

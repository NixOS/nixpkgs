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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "marin-m";
    repo = pname;
    rev = version;
    sha256 = "sha256-cUiy8ApeUv1K8SEH4APMTvbieGTt4kZYhyB9iGJd/IY=";
  };

  cargoSha256 = "sha256-Tlq4qDp56PXP4N1UyHjtQoRgDrc/19vIv8uml/lAqqc=";

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

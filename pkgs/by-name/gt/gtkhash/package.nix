{
  lib,
  fetchFromGitHub,
  stdenv,
  meson,
  ninja,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  glib,
  openssl,
  nettle,
  libb2,
  libgcrypt,
}:

stdenv.mkDerivation rec {
  pname = "gtkhash";
  version = "1.5";

  src = fetchFromGitHub {
    repo = "gtkhash";
    owner = "gtkhash";
    rev = "v${version}";
    hash = "sha256-XpgTolpTSsW3i0xk19tt4cn9qANoeiq7YnBBR6g8ioU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    glib
    openssl
    nettle
    libb2
    libgcrypt
  ];

  strictDeps = true;
  meta = with lib; {
    description = "Cross-platform desktop utility for computing message digests or checksums";
    homepage = "https://gtkhash.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "gtkhash";
    platforms = platforms.unix;
  };
}

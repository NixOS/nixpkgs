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

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkhash";
  version = "1.5";

  src = fetchFromGitHub {
    repo = "gtkhash";
    owner = "gtkhash";
    rev = "v${finalAttrs.version}";
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
  meta = {
    description = "Cross-platform desktop utility for computing message digests or checksums";
    homepage = "https://gtkhash.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    mainProgram = "gtkhash";
    platforms = lib.platforms.unix;
  };
})

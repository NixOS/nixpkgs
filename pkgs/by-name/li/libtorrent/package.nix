# Note: this is rakshasa's version of libtorrent, used mainly by rtorrent.
# *Do not* mistake it by libtorrent-rasterbar, used by Deluge, qbitttorent etc.
{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  cppunit,
  openssl,
  pkg-config,
  zlib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rakshasa-libtorrent";
  version = "0.15.5";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iFndmET8bQUg3iZ6c6WDCzSS2tx6sYJt+fEkPAaNm18=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cppunit
    openssl
    zlib
  ];

  configureFlags = [ "--enable-aligned=yes" ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/rakshasa/libtorrent";
    description = "BitTorrent library written in C++ for *nix, with focus on high performance and good code";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      ebzzry
      codyopel
      thiagokokada
    ];
    platforms = lib.platforms.unix;
  };
})

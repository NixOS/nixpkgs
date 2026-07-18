# Note: this is rakshasa's version of libtorrent, used mainly by rtorrent.
# *Do not* mistake it by libtorrent-rasterbar, used by Deluge, qbitttorent etc.
{
  autoreconfHook,
  cppunit,
  curl,
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtorrent-rakshasa";
  version = "0.16.17";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gwEbaAe1A5bPBrrQDBeKraAwdzgbcUYVZYt8Gjtugi8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cppunit
    curl
    openssl
    zlib
  ];

  configureFlags = [ "--enable-aligned=yes" ];

  enableParallelBuilding = true;

  meta = {
    description = "BitTorrent library written in C++ for *nix, with focus on high performance and good code";
    homepage = "https://github.com/rakshasa/libtorrent";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      thiagokokada
    ];
    platforms = lib.platforms.unix;
  };
})

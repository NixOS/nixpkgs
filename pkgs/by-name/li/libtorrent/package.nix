# Note: this is rakshasa's version of libtorrent, used mainly by rtorrent.
# *Do not* mistake it by libtorrent-rasterbar, used by Deluge, qbitttorent etc.
{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf-archive,
  autoreconfHook,
  cppunit,
  libsigcxx,
  openssl,
  pkg-config,
  zlib,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "rakshasa-libtorrent";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "v${version}";
    hash = "sha256-MDLAp7KFmVvHL+haWVYwWG8gnLkTh6g19ydRkbu9cIs=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cppunit
    libsigcxx
    openssl
    zlib
  ];

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
}

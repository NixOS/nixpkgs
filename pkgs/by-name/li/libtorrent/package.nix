# Note: this is rakshasa's version of libtorrent, used mainly by rtorrent.
# *Do not* mistake it by libtorrent-rasterbar, used by Deluge, qbitttorent etc.
{ lib
, stdenv
, fetchFromGitHub
, autoconf-archive
, autoreconfHook
, cppunit
, libsigcxx
, openssl
, pkg-config
, zlib
, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "rakshasa-libtorrent";
  version = "0.14.0-unstable-2024-09-29";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "08fb6635ba249665cb08a4de1b955288d25c21e1";
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

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/rakshasa/libtorrent";
    description = "BitTorrent library written in C++ for *nix, with focus on high performance and good code";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ebzzry codyopel thiagokokada ];
    platforms = lib.platforms.unix;
  };
}

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
  version = "0.13.8-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "ca6eed1c7e7985016689004eaeed2fb2a119e5f8";
    hash = "sha256-Hu0/T5NG7h+COLoOsfi2Uy0BVUPiEhkMhUhFo/JqZq0=";
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

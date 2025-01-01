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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "v${version}";
    hash = "sha256-FtuVDXH9vIdz+Wz7PLY2lRZkR+j9NYmgaHPDDx2SA98=";
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
}

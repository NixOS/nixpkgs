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
}:

stdenv.mkDerivation rec {
  pname = "rakshasa-libtorrent";
  version = "0.13.8+date=2021-08-07";

  src = fetchFromGitHub {
    owner = "rakshasa";
    repo = "libtorrent";
    rev = "53596afc5fae275b3fb5753a4bb2a1a7f7cf6a51";
    hash = "sha256-gyl/jfbptHz/gHkkVGWShhv1Z7o9fa9nJIz27U2A6wg=";
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

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/rakshasa/libtorrent";
    description = "BitTorrent library written in C++ for *nix, with focus on high performance and good code";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ebzzry codyopel ];
    platforms = platforms.unix;
  };
}

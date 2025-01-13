{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  openssl,
  boost,
  libevent,
  autoreconfHook,
  db4,
  miniupnpc,
  eject,
  pkg-config,
  hexdump,
}:

stdenv.mkDerivation rec {
  pname = "namecoind";
  version = "25.0";

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = "nc${version}";
    sha256 = "sha256-2KMK5Vb8osuaKbzI1aaPSYg+te+v9CEcGUkrVI6Fk54=";
  };

  patches = [
    # upnp: add compatibility for miniupnpc 2.2.8
    (fetchpatch2 {
      url = "https://github.com/namecoin/namecoin-core/commit/8acdf66540834b9f9cf28f16d389e8b6a48516d5.patch?full_index=1";
      hash = "sha256-oDvHUvwAEp0LJCf6QBESn38Bu359TcPpLhvuLX3sm6M=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    miniupnpc
    eject
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "https://namecoin.org";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}

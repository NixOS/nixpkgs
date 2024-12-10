{
  lib,
  stdenv,
  fetchFromGitHub,
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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

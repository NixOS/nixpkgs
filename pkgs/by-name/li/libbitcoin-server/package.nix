{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  boost,
  libbitcoin,
  libbitcoin-node,
  libbitcoin-protocol,
}:

stdenv.mkDerivation rec {
  pname = "libbitcoin-server";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AZWv1j1Vjj7vqSb5G8LPy4vi1uLiRJBQrlkk6UdT/JE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  propagatedBuildInputs = [
    libbitcoin
    libbitcoin-node
    libbitcoin-protocol
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Bitcoin full node and query server";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jacekpoz ];
    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}

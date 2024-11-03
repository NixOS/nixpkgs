{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  boost,
  libbitcoin,
  libbitcoin-blockchain,
  libbitcoin-network,
}:

stdenv.mkDerivation rec {
  pname = "libbitcoin-node";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jFlA1v8q59atUpPLgNF7oyHK92EQNS+NPm548oQ3Kx0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  propagatedBuildInputs = [
    libbitcoin
    libbitcoin-blockchain
    libbitcoin-network
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Bitcoin full node";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jacekpoz ];
    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}

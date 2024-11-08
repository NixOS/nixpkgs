{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  boost,
  libbitcoin,
  libbitcoin-consensus,
  libbitcoin-database,
  withConsensus ? true,
}:

stdenv.mkDerivation rec {
  pname = "libbitcoin-blockchain";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wLIqigDYTqP1yYbpPKWWaNW5JV1O1h4PFMsbu3MRTB0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  propagatedBuildInputs = [
    libbitcoin
    libbitcoin-database
  ] ++ (lib.optionals withConsensus [ libbitcoin-consensus ]);

  enableParallelBuilding = true;

  configureFlags =
    [
      "--with-tests=no"
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
    ]
    ++ (lib.optionals (!withConsensus) [
      "--with-consensus=no"
    ]);

  meta = with lib; {
    description = "Bitcoin blockchain library";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jacekpoz ];
    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}

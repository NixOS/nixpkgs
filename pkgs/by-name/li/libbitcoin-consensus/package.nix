{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  boost,
  libbitcoin,
}:

stdenv.mkDerivation rec {
  pname = "libbitcoin-consensus";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MVzWMtgadOTEGksUym9jb2WVI6Hkj28IT3Twdp1N2ag=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  propagatedBuildInputs = [ libbitcoin ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tests=no"
    "--with-boost=${boost.dev}"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Bitcoin consensus library";
    homepage = "https://libbitcoin.info/";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ jacekpoz ];
    # AGPL with a lesser clause
    license = licenses.agpl3Plus;
  };
}

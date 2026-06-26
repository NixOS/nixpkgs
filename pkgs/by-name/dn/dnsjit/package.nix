{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, makeWrapper
, autoreconfHook
, autoconf
, automake
, libpcap
, luajit
, lmdb
, libck
, gnutls
, lz4
}:

stdenv.mkDerivation rec {
  pname = "dnsjit";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsjit";
    rev = "03719c6538a019a9b3c857f0ff9d031208160027";
    sha256 = "sha256-NaJqrPWeTeCSnPGJUXn7vIGRRWwztxfbEI6Wb+q4/hc=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook libpcap luajit lmdb libck gnutls lz4 ];

  doCheck = true;

  meta = with lib; {
    description = "Engine for capturing, parsing and replaying DNS";
    homepage = "https://www.dns-oarc.net/tools/dnsjit";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ alsvartr ];
  };
}

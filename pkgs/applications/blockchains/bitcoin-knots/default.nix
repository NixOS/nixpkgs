{ lib, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, db5
, openssl
, boost
, zlib
, miniupnpc
, libevent
, protobuf
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "bitcoind-knots";
  version = "0.20.0";
  versionDate = "20200614";

  src = fetchFromGitHub {
    owner = "bitcoinknots";
    repo = "bitcoin";
    rev = "v${version}.knots${versionDate}";
    sha256 = "0c8k1154kcwz6q2803wx0zigvqaij1fi5akgfqlj3yl57jjw48jj";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl db5 openssl util-linux
                  protobuf boost zlib miniupnpc libevent ];

  configureFlags = [ "--with-incompatible-bdb"
                     "--with-boost-libdir=${boost.out}/lib" ];

  meta = with lib; {
    description = "An enhanced Bitcoin node software";
    homepage = "https://bitcoinknots.org/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}

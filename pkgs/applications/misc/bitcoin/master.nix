{ fetchFromGitHub, stdenv, openssl, autoreconfHook, db48, boost, zlib, miniupnpc, qt4
, utillinux, pkgconfig, protobuf, qrencode, gui ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.4";
  name = "bitcoin${toString (optional (!gui) "d")}-${version}";

  src = fetchFromGitHub {
    owner = "bitcoin";
    repo = "bitcoin";
    rev = "v${version}";
    sha256 = "071y6wz4slhpwm7vnp3ski6x8900f6nssh00zcj3f4vp0968n76m";
  };

  # hexdump from utillinux is required for tests
  buildInputs = [
    openssl db48 boost zlib miniupnpc utillinux pkgconfig protobuf autoreconfHook
  ] ++ optionals gui [ qt4 qrencode ];

  preCheck = ''
    # At least one test requires writing in $HOME
    HOME=$TMPDIR
  '';

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ];

  doCheck = true;

  enableParallelBuilding = true;

  passthru.walletName = "bitcoin";

  meta = {
      description = "Peer-to-peer electronic cash system";
      longDescription= ''
        Bitcoin is a free open source peer-to-peer electronic cash system that is
        completely decentralized, without the need for a central server or trusted
        parties.  Users hold the crypto keys to their own money and transact directly
        with each other, with the help of a P2P network to check for double-spending.
      '';
      homepage = "http://www.bitcoin.org/";
      maintainers = [ maintainers.roconnor ];
      license = licenses.mit;
      platforms = platforms.unix;
  };
}

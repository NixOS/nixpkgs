{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost, zeromq
, zlib, miniupnpc, qtbase ? null, qttools ? null, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "bitcoin";
    repo = "bitcoin";
    rev = "v${version}";
    sha256 = "03cs66bd99wni456b935kn6ckqq86bi6ixg1d7y7xdxnyclzdlm6";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib zeromq
                  miniupnpc protobuf libevent]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib"
                     "--disable-bench"
                   ] ++ optionals (!doCheck) [
                     "--disable-tests"
                     "--disable-gui-tests"
                   ]
                     ++ optionals withGui [ "--with-gui=qt5"
                                            "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
                                          ];

  # Fails with "This application failed to start because it could not
  # find or load the Qt platform plugin "minimal""
  doCheck = false;

  enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = http://www.bitcoin.org/;
    maintainers = with maintainers; [ roconnor AndersonTorres ];
    license = licenses.mit;
    # bitcoin needs hexdump to build, which doesn't seem to build on darwin at the moment.
    platforms = platforms.linux;
  };
}

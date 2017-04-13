{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "hivemind" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "unstable";

  src = fetchFromGitHub {
    owner = "bitcoin-hivemind";
    repo = "hivemind";
    rev = "147973cfe76867410578d91d6f0a8df105cab4e0";
    sha256 = "1ndqqma1b0sh2gn7cl8d9fg44q0g2g42jr2y0nifkjgfjn3c7l5h";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc protobuf libevent]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" 
                     "--with-incompatible-bdb"
                   ] ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-Peer oracle protocol";
    longDescription= ''
      Hivemind is a Peer-to-Peer Oracle Protocol which absorbs accurate data
      into a blockchain so that Bitcoin-users can speculate in Prediction
      Markets.
    '';
    homepage = "https://bitcoinhivemind.com";
    maintainers = with maintainers; [ canndrew ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

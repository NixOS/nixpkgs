{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db4, boost,
libevent, libtool, libuuid, qt4, protobuf, withGui }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "nc0.13.0rc1";
  name = "namecoin" + (toString (optional (!withGui) "d")) + "-" + version;

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = version;
    sha256 = "17zz0rm3js285w2assxp8blfx830rs0ambcsaqqfli9mnaik3m39";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db4 boost libtool libuuid
                  protobuf libevent ]
                  ++ optionals withGui [ qt4 ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = http://namecoin.info;
    license = licenses.mit;
    maintainers = with maintainers; [ doublec AndersonTorres ];
    platforms = platforms.linux;
  };
}

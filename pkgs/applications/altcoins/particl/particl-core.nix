{ stdenv
, autoreconfHook
, boost
, db48
, fetchurl
, libevent
, miniupnpc
, openssl
, pkgconfig
, zeromq
, zlib
, unixtools
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "particl-core-${version}";
  version     = "0.16.1.0";

  src = fetchurl {
    url = "https://github.com/particl/particl-core/archive/v${version}.tar.gz";
    sha256 = "0rfqywyrl6cgxn3ba91zsa88ph2yf9d1vn706xpyz19pfb6mjfbg";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [
    openssl db48 boost zlib miniupnpc libevent zeromq
    unixtools.hexdump
  ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  meta = {
    description = "Privacy-Focused Marketplace & Decentralized Application Platform";
    longDescription= ''
      An open source, decentralized privacy platform built for global person to person eCommerce.
    '';
    homepage = https://particl.io/;
    maintainers = with maintainers; [ demyanrogozhin ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

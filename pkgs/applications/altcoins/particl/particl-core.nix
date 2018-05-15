{ stdenv
, autoreconfHook
, boost
, db48
, fetchurl
, libevent
, libtool
, miniupnpc
, openssl
, pkgconfig
, utillinux
, zeromq
, zlib
, withGui
, unixtools
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "particl-core-${version}";
  version     = "0.16.0.5";

  src = fetchurl {
    url = "https://github.com/particl/particl-core/archive/v${version}.tar.gz";
    sha256 = "070crn6nnzrbcaj30w0qbybpm9kfd2ghnvmxp29gckgknw6n0vam";
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

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
, python3
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "particl-core-${version}";
  version = "0.17.0.2";

  src = fetchurl {
    url = "https://github.com/particl/particl-core/archive/v${version}.tar.gz";
    sha256 = "0bkxdayl0jrfhgz8qzqqpwzv0yavz3nwsn6c8k003jnbcw65fkhx";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib miniupnpc libevent zeromq unixtools.hexdump python3 ];

  configureFlags = [
    "--disable-bench"
    "--with-boost-libdir=${boost.out}/lib"
  ] ++ optionals (!doCheck) [
    "--enable-tests=no"
  ];

  # Always check during Hydra builds
  doCheck = true;
  preCheck = "patchShebangs test";
  enableParallelBuilding = true;

  meta = {
    description = "Privacy-Focused Marketplace & Decentralized Application Platform";
    longDescription= ''
      An open source, decentralized privacy platform built for global person to person eCommerce.
      RPC daemon and CLI client only.
    '';
    homepage = https://particl.io/;
    maintainers = with maintainers; [ demyanrogozhin ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

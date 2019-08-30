{ stdenv, fetchFromGitHub, autoreconfHook, boost, db48, fetchurl, libevent
, miniupnpc, openssl, pkgconfig, zeromq, zlib, unixtools, python3 }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "particl-core";

  version = "0.18.1.3";

  src = fetchFromGitHub {
    owner = "particl";
    repo = "particl-core";
    rev = "v${version}";
    sha256 = "1djfg5zhf9c0pvfybj56rq3rl9n41b9mmdsq7znrxh2zjkkiqdwy";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];

  buildInputs =
    [ openssl db48 boost zlib miniupnpc libevent zeromq unixtools.hexdump ];

  configureFlags = [ "--disable-bench" "--with-boost-libdir=${boost.out}/lib" ]
    ++ optionals (!doCheck) [ "--enable-tests=no" ];

  checkInputs = [ python3 ];

  # Always check during Hydra builds
  doCheck = true;

  checkFlags = [ "LC_ALL=C.UTF-8" ];

  preCheck = "patchShebangs test";

  enableParallelBuilding = true;

  meta = {
    description =
      "Privacy-Focused Marketplace & Decentralized Application Platform";
    longDescription = ''
      An open source, decentralized privacy platform built for global person to person eCommerce.
      RPC daemon and CLI client only.
    '';
    homepage = "https://particl.io/";
    maintainers = with maintainers; [ demyanrogozhin ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

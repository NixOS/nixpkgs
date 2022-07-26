{ lib
, stdenv
, autoreconfHook
, boost
, db48
, fetchFromGitHub
, libevent
, miniupnpc
, openssl
, pkg-config
, zeromq
, zlib
, unixtools
, python3
}:

with lib;

stdenv.mkDerivation rec {
  pname = "particl-core";
  version = "0.19.2.14";

  src = fetchFromGitHub {
    owner = "particl";
    repo = "particl-core";
    rev = "v${version}";
    sha256 = "sha256-gJLEMfEvQ35xjKt8iN/FXi2T/GBMSS7eUqOC8XHKPBg=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
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
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Privacy-Focused Marketplace & Decentralized Application Platform";
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

{ lib, stdenv
, autoreconfHook
, boost
, db48
, fetchurl
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

  src = fetchurl {
    url = "https://github.com/particl/particl-core/archive/v${version}.tar.gz";
    sha256 = "sha256-UMU3384r4RGVl0/7OPwdDva09vhQr+9Lqb1oD/PTva8=";
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
    description = "Privacy-Focused Marketplace & Decentralized Application Platform";
    longDescription= ''
      An open source, decentralized privacy platform built for global person to person eCommerce.
      RPC daemon and CLI client only.
    '';
    homepage = "https://particl.io/";
    maintainers = with maintainers; [ demyanrogozhin ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

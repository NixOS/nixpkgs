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

stdenv.mkDerivation rec {
  pname = "particl-core";
  version = "23.0.3.0";

  src = fetchFromGitHub {
    owner = "particl";
    repo = "particl-core";
    rev = "v${version}";
    sha256 = "sha256-jrIsErKeHP9CMUWsrD42RmfmApP7J091OLA5JNY0fe0=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib miniupnpc libevent zeromq unixtools.hexdump python3 ];

  configureFlags = [
    "--disable-bench"
    "--with-boost-libdir=${boost.out}/lib"
  ] ++ lib.optionals (!doCheck) [
    "--enable-tests=no"
  ];

  # Always check during Hydra builds
  doCheck = true;
  preCheck = "patchShebangs test";
  enableParallelBuilding = true;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
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

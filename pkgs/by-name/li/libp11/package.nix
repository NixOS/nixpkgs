{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "libp11";
  version = "0.4.18";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = "${pname}-${version}";
    sha256 = "sha256-bvVUiv8y5c0P9fHAFs1JX3V7xsorbKUmm0qt3l2SoQQ=";
  };

  configureFlags = [
    "--with-enginesdir=${placeholder "out"}/lib/engines"
    "--with-modulesdir=${placeholder "out"}/lib/ossl-module"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libtool
  ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  passthru = { inherit openssl; };

  meta = {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = "https://github.com/OpenSC/libp11";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}

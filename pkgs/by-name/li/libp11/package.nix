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
  version = "0.4.17";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = "${pname}-${version}";
    sha256 = "sha256-ST1st+bktGu4G7m8BXuUk+WsTDBj7BcfNFGiiZt1obU=";
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

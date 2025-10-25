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
  version = "0.4.16";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = "${pname}-${version}";
    sha256 = "sha256-uuFHchf5skoNtyXTmyGHB67hcuI1N2ILasFcf7scTWo=";
  };

  configureFlags = [
    "--with-enginesdir=${placeholder "out"}/lib/engines"
    "--with-modulesdir=${placeholder "out"}/lib/ossl-modules"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    libtool
  ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  passthru = { inherit openssl; };

  meta = with lib; {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = "https://github.com/OpenSC/libp11";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ joinemm ];
  };
}

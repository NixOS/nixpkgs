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
  version = "0.4.12";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = "${pname}-${version}";
    sha256 = "sha256-Xqjl12xT30ZXWYzPWNN3jWY9pxojhd7Kq0OC7rABt4M=";
  };

  configureFlags = [
    "--with-enginesdir=${placeholder "out"}/lib/engines"
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
  };
}

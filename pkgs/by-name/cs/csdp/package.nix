{
  lib,
  stdenv,
  fetchurl,
  blas,
  gfortran,
  lapack,
}:

stdenv.mkDerivation rec {
  pname = "csdp";
  version = "6.1.1";

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Csdp/Csdp-${version}.tgz";
    sha256 = "1f9ql6cjy2gwiyc51ylfan24v1ca9sjajxkbhszlds1lqmma8n05";
  };

  buildInputs = [
    blas
    gfortran.cc.lib
    lapack
  ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local/bin $out/bin
  '';

  preInstall = ''
    rm -f INSTALL
    mkdir -p $out/bin
  '';

  meta = {
    homepage = "https://projects.coin-or.org/Csdp";
    license = lib.licenses.cpl10;
    maintainers = [ lib.maintainers.roconnor ];
    description = "C Library for Semidefinite Programming";
    platforms = lib.platforms.unix;
  };
}

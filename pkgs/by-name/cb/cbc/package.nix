{
  lib,
  stdenv,
  fetchurl,
  zlib,
  bzip2,
}:

stdenv.mkDerivation rec {
  pname = "cbc";
  version = "2.10.4";

  # Note: Cbc 2.10.5 contains Clp 1.17.5 which hits this bug
  # that breaks or-tools https://github.com/coin-or/Clp/issues/130

  src = fetchurl {
    url = "https://www.coin-or.org/download/source/Cbc/Cbc-${version}.tgz";
    sha256 = "0zq66j1vvpslswhzi9yfgkv6vmg7yry4pdmfgqaqw2vhyqxnsy39";
  };

  # or-tools has a hard dependency on Cbc static libraries, so we build both
  configureFlags = [
    "-C"
    "--enable-static"
  ] ++ lib.optionals stdenv.cc.isClang [ "CXXFLAGS=-std=c++14" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  buildInputs = [
    zlib
    bzip2
  ];

  # FIXME: move share/coin/Data to a separate output?

  meta = {
    homepage = "https://projects.coin-or.org/Cbc";
    license = lib.licenses.epl10;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    description = "Mixed integer programming solver";
  };
}

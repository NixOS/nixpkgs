{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  cgl,
  clp,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cbc";
  version = "2.10.12";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Cbc";
    tag = "releases/${finalAttrs.version}";
    sha256 = "sha256-0Sz4/7CRKrArIUy/XxGIP7WMmICqDJ0VxZo62thChYQ=";
  };

  # or-tools has a hard dependency on Cbc static libraries, so we build both
  configureFlags = [
    "-C"
    "--enable-static"
  ]
  ++ lib.optionals stdenv.cc.isClang [ "CXXFLAGS=-std=c++14" ];

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  buildInputs = [
    bzip2
    zlib
  ];

  # cbc lists cgl and clp in its .pc requirements, so it needs to be propagated.
  propagatedBuildInputs = [
    cgl
    clp
  ];

  # FIXME: move share/coin/Data to a separate output?

  meta = {
    homepage = "https://projects.coin-or.org/Cbc";
    license = lib.licenses.epl10;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    description = "Mixed integer programming solver";
  };
})

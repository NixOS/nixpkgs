{
  fetchFromGitHub,
  lib,
  stdenv,
  boost,
  zlib,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "maeparser";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "maeparser";
    rev = "v${version}";
    sha256 = "sha256-+eCTOU0rqFQC87wcxgINGLsULfbIr/wKxQTkRR59JVc=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    zlib
  ];

  meta = {
    homepage = "https://github.com/schrodinger/maeparser";
    description = "Maestro file parser";
    maintainers = [ lib.maintainers.rmcgibbo ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}

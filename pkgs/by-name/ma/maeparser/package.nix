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
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "maeparser";
    rev = "v${version}";
    sha256 = "sha256-LTE1YGw6DiWnpUGB9x3vFVArcYd8zO49b4tqpqK30eA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    zlib
  ];

  meta = with lib; {
    homepage = "https://github.com/schrodinger/maeparser";
    description = "Maestro file parser";
    maintainers = [ maintainers.rmcgibbo ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "libfann";
  version = "2.2.0-unstable-2025-10-13";

  src = fetchFromGitHub {
    owner = "libfann";
    repo = "fann";
    rev = "3907e1b37f94ed606b627c55dd2238956046a19b";
    sha256 = "sha256-UdEpUD7ASrqygwFgW4CdCDGIJtUTKeJbHZDnnQI5jSI=";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    homepage = "http://leenissen.dk/fann/wp/";
    description = "Fast Artificial Neural Network Library";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
}

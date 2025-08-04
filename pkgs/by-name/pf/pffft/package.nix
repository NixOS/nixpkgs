{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "pffft";
  version = "0-unstable-2022-04-10";

  src = fetchFromGitHub {
    owner = "marton78";
    repo = "pffft";
    rev = "08f5ed2618ac06d7dcc83d209d7253dc215274d5";
    sha256 = "sha256-9LfLQ17IRsbEwGQJZzhW2Av4en1KuJVicLrS2AyjUZY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Pretty Fast FFT (PFFFT) library";
    homepage = "https://github.com/marton78/pffft";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}

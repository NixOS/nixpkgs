{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "pffft";
  version = "unstable-2022-04-10";

  src = fetchFromGitHub {
    owner = "marton78";
    repo = pname;
    rev = "08f5ed2618ac06d7dcc83d209d7253dc215274d5";
    sha256 = "sha256-9LfLQ17IRsbEwGQJZzhW2Av4en1KuJVicLrS2AyjUZY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Pretty Fast FFT (PFFFT) library";
    homepage = "https://github.com/marton78/pffft";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}

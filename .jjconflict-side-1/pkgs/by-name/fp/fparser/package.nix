{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "fparser";
  version = "unstable-2015-09-25";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "fparser";
    rev = "a59e1f51e32096bfe2a0a2640d5dffc7ae6ba37b";
    sha256 = "0wayml1mlyi922gp6am3fsidhzsilziksdn5kbnpcln01h8555ad";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++ Library for Evaluating Mathematical Functions";
    homepage = "https://github.com/thliebig/fparser";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ matthuszagh ];
    platforms = platforms.linux;
  };
}

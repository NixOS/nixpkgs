{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation rec {
  pname = "rang";
  version = "3.1.0";
  src = fetchFromGitHub {
    owner = "agauniyal";
    repo = "rang";
    rev = "cabe04d6d6b05356fa8f9741704924788f0dd762";
    sha256 = "0v2pz0l2smagr3j4abjccshg4agaccfz79m5ayvrvqq5d4rlds0s";
  };
  nativeBuildInputs = [ cmake ];
  meta = with lib; {
    description =
      "A Minimal, Header only Modern c++ library for terminal goodies";
    homepage = "https://agauniyal.github.io/rang/";
    license = licenses.unlicense;
    maintainers = [ maintainers.HaoZeke ];
  };
}

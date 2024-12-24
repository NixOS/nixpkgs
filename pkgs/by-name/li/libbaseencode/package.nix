{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libbaseencode";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WiE+ZMX4oZieER1pu43aSWytkxfkQdX+S3JI98XPpL4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library written in C for encoding and decoding data using base32 or base64 (RFC-4648)";
    homepage = "https://github.com/paolostivanin/libbaseencode";
    license = licenses.asl20;
    maintainers = with maintainers; [ alexbakker ];
  };
}

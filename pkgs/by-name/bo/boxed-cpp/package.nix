{ lib, stdenv, fetchFromGitHub, cmake, catch2 }:

stdenv.mkDerivation (final: {
  pname = "boxed-cpp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "boxed-cpp";
    rev = "v${final.version}";
    hash = "sha256-o+qAEpP2inGQVXJ1i3HBee0fXQYR2HCyBY4Urk8ohMI=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ catch2 ];

  meta = with lib; {
    description = "Boxing primitive types in C++";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.moni ];
  };
})

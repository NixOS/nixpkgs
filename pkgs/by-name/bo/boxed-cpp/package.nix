{ lib, stdenv, fetchFromGitHub, cmake, catch2 }:

stdenv.mkDerivation (final: {
  pname = "boxed-cpp";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "boxed-cpp";
    rev = "v${final.version}";
    hash = "sha256-Z/dfSa/6SnzLWnFCXjJUbTBNa5dFZna099Crbcya/Dw=";
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

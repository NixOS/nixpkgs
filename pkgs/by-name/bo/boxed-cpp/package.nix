{ lib, stdenv, fetchFromGitHub, cmake, catch2 }:

stdenv.mkDerivation (final: {
  pname = "boxed-cpp";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "boxed-cpp";
    rev = "v${final.version}";
    hash = "sha256-8qhP1yXdRTbU/IbDAaQrdjzIMM5ZjCAULI07dw44XcE=";
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

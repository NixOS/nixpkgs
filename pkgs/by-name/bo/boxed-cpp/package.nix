{ lib, stdenv, fetchFromGitHub, cmake, catch2 }:

stdenv.mkDerivation (final: {
  pname = "boxed-cpp";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "boxed-cpp";
    rev = "v${final.version}";
    hash = "sha256-uZ/wT159UuEcTUtoQyt0D59z2wnLT5KpeeCpjyij198=";
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  zlib,
  catch2,
}:

stdenv.mkDerivation rec {
  pname = "seasocks";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "mattgodbolt";
    repo = "seasocks";
    rev = "v${version}";
    sha256 = "sha256-R1McxZm2qsUoggFGfL587g+8eQf7si56xVkR8B8nehQ=";
  };

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp src/test/c/catch/catch2/catch.hpp
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    zlib
    python3
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mattgodbolt/seasocks";
    description = "Tiny embeddable C++ HTTP and WebSocket server";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fredeb ];
  };
}

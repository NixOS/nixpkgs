{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml,
}:

stdenv.mkDerivation rec {
  pname = "csfml";
  version = "2.5.2";
  src = fetchFromGitHub {
    owner = "SFML";
    repo = "CSFML";
    rev = version;
    sha256 = "sha256-A5C/4SnxUX7mW1wkPWJWX3dwMhrJ79DkBuZ7UYzTOqE=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml ];
  cmakeFlags = [ "-DCMAKE_MODULE_PATH=${sfml}/share/SFML/cmake/Modules/" ];

  meta = with lib; {
    homepage = "https://www.sfml-dev.org/";
    description = "Simple and fast multimedia library";
    longDescription = ''
      SFML is a simple, fast, cross-platform and object-oriented multimedia API.
      It provides access to windowing, graphics, audio and network.
      It is written in C++, and has bindings for various languages such as C, .Net, Ruby, Python.
    '';
    license = licenses.zlib;
    maintainers = [ maintainers.jpdoyle ];
    platforms = platforms.linux;
  };
}

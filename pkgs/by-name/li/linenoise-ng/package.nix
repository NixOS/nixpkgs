{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "linenoise-ng";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "arangodb";
    repo = "linenoise-ng";
    rev = "v${version}";
    sha256 = "176iz0kj0p8d8i3jqps4z8xkxwl3f1986q88i9xg5fvqgpzsxp20";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/arangodb/linenoise-ng";
    description = "Small, portable GNU readline replacement for Linux, Windows and MacOS which is capable of handling UTF-8 characters";
    maintainers = [ ];
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
}

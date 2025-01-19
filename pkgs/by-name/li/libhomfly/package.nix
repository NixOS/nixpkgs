{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  boehmgc,
}:

stdenv.mkDerivation rec {
  version = "1.02r6";
  pname = "libhomfly";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libhomfly";
    rev = version;
    sha256 = "sha256-s1Hgy6S9+uREKsgjOVQdQfnds6oSLo5UWTrt5DJnY2s=";
  };

  buildInputs = [
    boehmgc
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/miguelmarco/libhomfly/";
    description = "Library to compute the homfly polynomial of knots and links";
    license = lib.licenses.unlicense;
    maintainers = lib.teams.sage.members;
    platforms = lib.platforms.all;
  };
}

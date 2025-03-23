{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libcdada";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "msune";
    repo = "libcdada";
    rev = "v${version}";
    hash = "sha256-x//22FvgxIGL9H2whMAVCTyI9gAjlMWkEmpOAcoeOgE=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--without-tests"
    "--without-examples"
  ];

  meta = with lib; {
    description = "Library for basic data structures in C";
    longDescription = ''
      Basic data structures in C: list, set, map/hashtable, queue... (libstdc++ wrapper)
    '';
    homepage = "https://github.com/msune/libcdada";
    license = licenses.bsd2;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.unix;
  };
}

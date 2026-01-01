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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Library for basic data structures in C";
    longDescription = ''
      Basic data structures in C: list, set, map/hashtable, queue... (libstdc++ wrapper)
    '';
    homepage = "https://github.com/msune/libcdada";
<<<<<<< HEAD
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    platforms = lib.platforms.unix;
=======
    license = licenses.bsd2;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

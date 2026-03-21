{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcdada";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "msune";
    repo = "libcdada";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x//22FvgxIGL9H2whMAVCTyI9gAjlMWkEmpOAcoeOgE=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  configureFlags = [
    "--without-tests"
    "--without-examples"
  ];

  meta = {
    description = "Library for basic data structures in C";
    longDescription = ''
      Basic data structures in C: list, set, map/hashtable, queue... (libstdc++ wrapper)
    '';
    homepage = "https://github.com/msune/libcdada";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ _0x4A6F ];
    platforms = lib.platforms.unix;
  };
})

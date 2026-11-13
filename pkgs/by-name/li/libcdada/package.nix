{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcdada";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "msune";
    repo = "libcdada";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z4Nr0jE+nuBmLirbHnC98GlXV0n9j09ps7uWgOLN9nM=";
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

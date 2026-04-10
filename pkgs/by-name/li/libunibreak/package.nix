{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libunibreak";
  version = "7_0";

  src =
    let
      rev_version = lib.replaceStrings [ "." ] [ "_" ] version;
    in
    fetchFromGitHub {
      owner = "adah1972";
      repo = "libunibreak";
      rev = "libunibreak_${rev_version}";
      sha256 = "sha256-J+/L5pFudppf0l0Gk/6/Rwz5I59p9Aw11cUEPRPGP/8=";
    };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/adah1972/libunibreak";
    description = "Implementation of line breaking and word breaking algorithms as in the Unicode standard";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}

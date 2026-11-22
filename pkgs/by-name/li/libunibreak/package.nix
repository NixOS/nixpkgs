{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libunibreak";
  version = "8_0_1";

  src =
    let
      rev_version = lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version;
    in
    fetchFromGitHub {
      owner = "adah1972";
      repo = "libunibreak";
      tag = "libunibreak_${rev_version}";
      hash = "sha256-CjwdIuh2X4dLgSdGrMtnqZPPzOj59We+TI/WJ3bntrY=";
    };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/adah1972/libunibreak";
    changelog = "https://github.com/adah1972/libunibreak/blob/${finalAttrs.src.tag}/NEWS";
    description = "Implementation of line breaking and word breaking algorithms as in the Unicode standard";
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

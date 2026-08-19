{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mosml";
  version = "2.10.1";

  buildInputs = [
    gmp
    perl
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  # Version 2.10.1 (dated August 2014) breaks with newer compilers
  env.NIX_CFLAGS_COMPILE = "-fpermissive -std=gnu17";

  src = fetchFromGitHub {
    owner = "kfl";
    repo = "mosml";
    rev = "ver-${finalAttrs.version}";
    sha256 = "sha256-GK39WvM7NNhoC5f0Wjy4/5VWT+Rbh2qo+W71hWrbPso=";
  };

  setSourceRoot = ''export sourceRoot="$(echo */src)"'';

  # MosML needs a specific RPATH entry pointing to $(out)/lib (added
  # by the build system), which patchelf will remove.
  dontPatchELF = true;

  meta = {
    description = "Light-weight implementation of Standard ML";
    longDescription = ''
      Moscow ML is a light-weight implementation of Standard ML (SML), a strict
      functional language used in teaching and research.
    '';
    homepage = "https://mosml.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vaibhavsagar ];
  };
})

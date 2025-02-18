{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  perl,
}:

stdenv.mkDerivation rec {
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

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  src = fetchFromGitHub {
    owner = "kfl";
    repo = "mosml";
    rev = "ver-${version}";
    sha256 = "sha256-GK39WvM7NNhoC5f0Wjy4/5VWT+Rbh2qo+W71hWrbPso=";
  };

  setSourceRoot = ''export sourceRoot="$(echo */src)"'';

  # MosML needs a specific RPATH entry pointing to $(out)/lib (added
  # by the build system), which patchelf will remove.
  dontPatchELF = true;

  meta = with lib; {
    description = "Light-weight implementation of Standard ML";
    longDescription = ''
      Moscow ML is a light-weight implementation of Standard ML (SML), a strict
      functional language used in teaching and research.
    '';
    homepage = "https://mosml.org/";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vaibhavsagar ];
  };
}

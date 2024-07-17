{
  stdenv,
  lib,
  fetchFromSourcehut,
  bearssl,
  scdoc,
}:

stdenv.mkDerivation rec {
  pname = "gmni";
  version = "1.0";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "gmni";
    rev = version;
    sha256 = "sha256-3MFNAI/SfFigNfitfFs3o9kkz7JeEflMHiH7iJpLfi4=";
  };

  nativeBuildInputs = [ scdoc ];
  buildInputs = [ bearssl ];

  # Fix build on `gcc-13`:
  #       inlined from 'xt_end_chain' at src/tofu.c:82:3,
  #   ...-glibc-2.38-27-dev/include/bits/stdio2.h:54:10: error: '__builtin___snprintf_chk' specified bound 4 exceeds destination size 3 [-Werror=stringop-overflow]
  #
  # The overflow will not happen in practice, but `snprintf()` gets
  # passed one more byte than available.
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "A Gemini client";
    homepage = "https://git.sr.ht/~sircmpwn/gmni";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      bsima
      jb55
    ];
    platforms = platforms.linux;
  };
}

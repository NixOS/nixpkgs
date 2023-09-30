{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lizard";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = "lizard";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Tsp6+49PK+tXoe5rTIMHTkBeRGQMbyzzMrz0skwnlZc=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An efficient compressor with very fast decompression";
    homepage = "https://github.com/inikep/lizard";
    license = with licenses; [ bsd2 gpl2Plus ];
    maintainers = with maintainers; [ rflg ];
    platforms = platforms.all;
  };
})

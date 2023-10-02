{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "lizard";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "inikep";
    repo = "lizard";
    rev = "v${version}";
    hash = "sha256-Tsp6+49PK+tXoe5rTIMHTkBeRGQMbyzzMrz0skwnlZc=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An efficient compressor with very fast decompression.";
    homepage = "https://github.com/inikep/lizard";
    changelog = "https://github.com/inikep/lizard/blob/${src.rev}/NEWS";
    license = with licenses; [ bsd2 gpl2Plus ];
    maintainers = with maintainers; [ rflg ];
    platforms = platforms.all;
  };
}

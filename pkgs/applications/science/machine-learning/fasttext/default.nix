{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "fasttext";
  version = "0.9.2-unstable-2023-11-28";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastText";
    rev = "6c2204ba66776b700095ff73e3e599a908ffd9c3";
    hash = "sha256-lSIah4T+QqZwCRpeI3mxJ7PZT6pSHBO26rcEFfK8DSk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Library for text classification and representation learning";
    mainProgram = "fasttext";
    homepage = "https://fasttext.cc/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}

{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "fasttext";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastText";
    rev = "v${version}";
    sha256 = "07cz2ghfq6amcljaxpdr5chbd64ph513y8zqmibfx2xwfp74xkhn";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Library for text classification and representation learning";
    homepage = "https://fasttext.cc/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.danieldk ];
  };
}

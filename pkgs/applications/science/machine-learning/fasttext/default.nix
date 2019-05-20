{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "fasttext";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastText";
    rev = version;
    sha256 = "1fcrz648r2s80bf7vc0l371xillz5jk3ldaiv9jb7wnsyri831b4";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Library for text classification and representation learning";
    homepage = https://fasttext.cc/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.danieldk ];
  };
}

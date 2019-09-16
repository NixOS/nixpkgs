{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "fasttext";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "fastText";
    rev = "v${version}";
    sha256 = "1cbzz98qn8aypp4r5kwwwc9wiq5bwzv51kcsb15xjfs9lz8h3rii";
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

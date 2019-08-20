{ mkDerivation, fetchFromGitHub, cmake, qttools, qtbase }:

mkDerivation rec {
  pname = "heimer";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "0k1p92viwj2p357rp2ypfljkzxrcvrq3lc76f0872c55zrf253wp";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qttools qtbase ];
}

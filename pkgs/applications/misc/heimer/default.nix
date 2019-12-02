{ mkDerivation, fetchFromGitHub, cmake, qttools, qtbase }:

mkDerivation rec {
  pname = "heimer";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "juzzlin";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "1gw4w6cvr3vb4zdb1kq8gwmadh2lb0jd0bd2hc7cw2d5kdbjaln7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qttools qtbase ];
}

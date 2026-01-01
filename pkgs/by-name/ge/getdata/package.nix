{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
}:
stdenv.mkDerivation rec {
  pname = "getdata";
  version = "0.11.0";
  src = fetchFromGitHub {
    owner = "ketiltrout";
    repo = "getdata";
    rev = "v${version}";
    sha256 = "sha256-fuFakbkxDwDp6Z9VITPIB8NiYRSp98Ub1y5SC6W5S1E=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

<<<<<<< HEAD
  meta = {
    description = "Reference implementation of the Dirfile Standards";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.vbgl ];
=======
  meta = with lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://getdata.sourceforge.net/";
  };
}

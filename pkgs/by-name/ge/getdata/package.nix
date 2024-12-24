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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fuFakbkxDwDp6Z9VITPIB8NiYRSp98Ub1y5SC6W5S1E=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  meta = with lib; {
    description = "Reference implementation of the Dirfile Standards";
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
    maintainers = [ maintainers.vbgl ];
    homepage = "https://getdata.sourceforge.net/";
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "getdata";
  version = "0.11.0";
  src = fetchFromGitHub {
    owner = "ketiltrout";
    repo = "getdata";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fuFakbkxDwDp6Z9VITPIB8NiYRSp98Ub1y5SC6W5S1E=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libtool ];

  meta = {
    description = "Reference implementation of the Dirfile Standards";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://getdata.sourceforge.net/";
  };
})

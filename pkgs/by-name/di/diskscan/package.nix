{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ncurses,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "diskscan";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "baruch";
    repo = "diskscan";
    rev = version;
    sha256 = "sha256-2y1ncPg9OKxqImBN5O5kXrTsuwZ/Cg/8exS7lWyZY1c=";
  };

  patches = [
    # cmake-4 support:
    #   https://github.com/baruch/diskscan/pull/77
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/baruch/diskscan/commit/6e342469dcab32be7a33109a4d394141d5c905b5.patch";
      hash = "sha256-05ctYPmGWTJRUc4aN35fvb0ITwIZlQdIweH7tSQ0RjA=";
    })
  ];

  buildInputs = [
    ncurses
    zlib
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/baruch/diskscan";
    description = "Scan HDD/SSD for failed and near failed sectors";
    platforms = with platforms; linux;
    maintainers = with maintainers; [ peterhoeg ];
    license = licenses.gpl3;
    mainProgram = "diskscan";
  };
}

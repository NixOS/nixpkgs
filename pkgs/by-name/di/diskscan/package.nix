{
  lib,
  stdenv,
  fetchFromGitHub,
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

  buildInputs = [
    ncurses
    zlib
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/baruch/diskscan";
    description = "Scan HDD/SSD for failed and near failed sectors";
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ peterhoeg ];
    license = lib.licenses.gpl3;
    mainProgram = "diskscan";
  };
}

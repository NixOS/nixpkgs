{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, pkg-config
, which
, yacc
, gnuplot
, libxls
, libxml2
, libzip
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "sc-im";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "sha256-AIYa3d1ml1f5GNLKijeFPX+UabgEqzdXiP60BGvBPsQ=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    which
    yacc
  ];

  buildInputs = [
    gnuplot
    libxls
    libxml2
    libzip
    ncurses
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram "$out/bin/sc-im" --prefix PATH : "${lib.makeBinPath [ gnuplot ]}"
  '';

  meta = with lib; {
    homepage = "https://github.com/andmarti1424/sc-im";
    description = "An ncurses spreadsheet program for terminal";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}

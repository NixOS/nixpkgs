{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "sha256-/eG2BdkyfEGoSzPu6jT+Bn1RZTGT1D3etGj1tYchm1M=";
  };

  sourceRoot = "${src.name}/src";

  # make default colors readable on dark background
  patches = [
    (fetchpatch {
      url = "https://github.com/andmarti1424/sc-im/commit/78d2fdaaf2c578691e68fb5bd773803cb967ddba.patch";
      sha256 = "09716zsqa9qdsj2qpkji8wlzsmp9gl66ggvrg7lmrwwnvli2zn2w";
    })
    (fetchpatch {
      url = "https://github.com/andmarti1424/sc-im/commit/f29d6605c8170febcec0dea7bda9613bee3b7011.patch";
      sha256 = "1zs1sb23g0k6lig4d0qdzq1wdhcdzl424ch567zyjl191lyhsjyg";
    })
  ];

  patchFlags = [ "-p2" ];

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

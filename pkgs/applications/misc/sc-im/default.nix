{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, pkg-config
, which
, bison
, gnuplot
, libxls
, libxlsxwriter
, libxml2
, libzip
, ncurses
, xlsSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "sc-im";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "sha256-nNOifSYbmJjuw6c8TerIQRlhCwbs7GnzD2J7O3vs0gI=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    which
    bison
  ];

  buildInputs = [
    gnuplot
    libxml2
    libzip
    ncurses
  ] ++ lib.optionals xlsSupport [
    libxls
    libxlsxwriter
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  postInstall = ''
    wrapProgram "$out/bin/sc-im" --prefix PATH : "${lib.makeBinPath [ gnuplot ]}"
  '';

  meta = with lib; {
    changelog = "https://github.com/andmarti1424/sc-im/blob/${src.rev}/CHANGES";
    homepage = "https://github.com/andmarti1424/sc-im";
    description = "Ncurses spreadsheet program for terminal";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}

{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # libxls and libxlsxwriter are not found without the patch
    # https://github.com/andmarti1424/sc-im/pull/542
    (fetchpatch {
      name = "use-pkg-config-for-libxls-and-libxlsxwriter.patch";
      url = "https://github.com/andmarti1424/sc-im/commit/b62dc25eb808e18a8ab7ee7d8eb290e34efeb075.patch";
      sha256 = "1yn32ps74ngzg3rbkqf8dn0g19jv4xhxrfgx9agnywf0x8gbwjh3";
    })
  ];

  patchFlags = [ "-p2" ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    which
    bison
  ];

  buildInputs = [
    gnuplot
    libxls
    libxlsxwriter
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

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  gmp,
  zlib,
}:

stdenv.mkDerivation {
  pname = "scipopt-zimpl";
  version = "362";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "zimpl";
    rev = "v362";
    sha256 = "juqAwzqBArsFXmz7L7RQaE78EhQdP5P51wQFlCoo7/o=";
  };

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  buildInputs = [
    gmp
    zlib
  ];

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    description = "Zuse Institut Mathematical Programming Language";
    longDescription = ''
      ZIMPL is a little language to translate the mathematical model of a
      problem into a linear or (mixed-)integer mathematical program
      expressed in .lp or .mps file format which can be read by a LP or MIP
      solver.

      If you use Zimpl for research and publish results, the best way
      to refer to Zimpl is to cite my Ph.d. thesis:

      @PHDTHESIS{Koch2004,
         author      = "Thorsten Koch",
         title       = "Rapid Mathematical Programming",
         year        = "2004",
         school      = "Technische {Universit\"at} Berlin",
         url         = "http://www.zib.de/Publications/abstracts/ZR-04-58/",
         note        = "ZIB-Report 04-58",
      }
    '';
    license = lib.licenses.lgpl3;
    homepage = "https://zimpl.zib.de";
  };
}

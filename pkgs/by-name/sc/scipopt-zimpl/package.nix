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

stdenv.mkDerivation (finalAttrs: {
  pname = "scipopt-zimpl";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "zimpl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ataepqBfdA7CgqPhbw+Xy7PC3VZTLcSrF2/xnFyx+YI=";
  };

  postPatch = ''
    chmod +x check/check.sh
  '';

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  buildInputs = [
    gmp
    zlib
  ];
  doCheck = true;

  checkPhase = ''
    runHook preCheck
    pushd ../check
    ./check.sh ../build/bin/zimpl
    popd
    runHook postCheck
  '';
  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    platforms = lib.platforms.linux;
    broken = stdenv.isDarwin;
    changelog = "https://zimpl.zib.de/download/CHANGELOG.txt";
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
    license = lib.licenses.lgpl3Plus;
    homepage = "https://zimpl.zib.de";
    mainProgram = "zimpl";
  };
})

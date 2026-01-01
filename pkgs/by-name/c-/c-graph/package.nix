{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  gnuplot,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "c-graph";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://gnu/c-graph/c-graph-${version}.tar.gz";
    hash = "sha256-LSZ948nXXY3pXltR2hHnql6YEpHumjTvbtz4/qUIRCQ=";
  };

  nativeBuildInputs = [
    gfortran
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/c-graph --prefix PATH : ${lib.makeBinPath [ gnuplot ]}
  '';

<<<<<<< HEAD
  meta = {
    description = "Tool for Learning about Convolution";
    homepage = "https://www.gnu.org/software/c-graph/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Tool for Learning about Convolution";
    homepage = "https://www.gnu.org/software/c-graph/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "c-graph";
  };
}

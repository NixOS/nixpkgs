{
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  rPackages,
  rWrapper,
  stdenv,
}:

let
  my-r-packages = rWrapper.override {
    packages = with rPackages; [
      foreach
      doParallel
      randomForest
    ];
  };
  transcriptome-url = "https://kumisystems.dl.sourceforge.net/project/splicing-prediction-pipeline/transcriptome/";

  transcriptome19 = fetchurl {
    url = transcriptome-url + "/transcriptome_hg19.RData";
    hash = "sha256-E8UmHoNoySSIde+TRE6bxVP0PrccpKDvIHBGCvWnYOw=";
  };

  transcriptome38 = fetchurl {
    url = transcriptome-url + "/transcriptome_hg38.RData";
    hash = "sha256-mQMMZVN1byXMYjFoRdezmoZtnhUur2CHOP/j/pmw8as=";
  };

in

stdenv.mkDerivation {
  pname = "spip";
  version = "0-unstable-2023-04-19";

  src = fetchFromGitHub {
    owner = "raphaelleman";
    repo = "SPiP";
    rev = "cae95fe0ee7a2602630b7a4eacbf7cfa0e1763f0";
    hash = "sha256-/CufUaQYnsdo8Rij/24JmixPgMi7o1CApLxeTneWAVc=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInput = [ my-r-packages ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp SPiPv2.1_main.r $out/
    cp -r RefFiles $out/
    ln -s ${transcriptome19} $out/RefFiles/transcriptome_hg19.RData
    ln -s ${transcriptome38} $out/RefFiles/transcriptome_hg38.RData
    makeWrapper ${my-r-packages}/bin/Rscript $out/bin/spip \
      --add-flags "$out/SPiPv2.1_main.r"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Random forest model for splice prediction in genomics";
    license = licenses.mit;
    homepage = "https://github.com/raphaelleman/SPiP";
    maintainers = with maintainers; [ apraga ];
    platforms = platforms.unix;
    mainProgram = "spip";
  };
}

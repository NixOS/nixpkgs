{ lib
, python3
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonApplication rec {
  pname = "arxiv-latex-cleaner";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "google-research";
    repo = "arxiv-latex-cleaner";
    rev = "v${version}";
    hash = "sha256-1IWSDKEoAM4hBKAEEcPq7X89WYDprifDL2GTEJQtdcQ=";
  };

  propagatedBuildInputs = with python3Packages; [
    pillow
    pyyaml
    regex
    absl-py
  ];

  checkPhase = ''
    runHook preCheck
    ${python3.interpreter} -m unittest arxiv_latex_cleaner.tests.arxiv_latex_cleaner_test
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/google-research/arxiv-latex-cleaner";
    description = "Easily clean the LaTeX code of your paper to submit to arXiv";
    license = licenses.asl20;
    maintainers = with maintainers; [ arkivm ];
  };
}

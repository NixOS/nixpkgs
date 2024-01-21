{ lib
, python3
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonApplication rec {
  pname = "arxiv-latex-cleaner";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "google-research";
    repo = "arxiv-latex-cleaner";
    rev = "refs/tags/v${version}";
    hash = "sha256-kM1eCzXipJ6GuYFA9Na2C0HtwHLotmE63nyUZ+9wkkk=";
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

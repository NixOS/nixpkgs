{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "multiqc";
  version = "1.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MultiQC";
    repo = "MultiQC";
    rev = "v${version}";
    hash = "sha256-Vdp5Ev0gPuyLGFMCXK4Z8FNhkWXcU43/uHk+KiIoWIk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    python3.pkgs.importlib-metadata
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    matplotlib
    networkx
    numpy
    click
    coloredlogs
    future
    jinja2
    markdown
    packaging
    pyyaml
    requests
    rich
    rich-click
    spectra
    humanize
    pyaml-env
  ];

  pythonImportsCheck = [ "multiqc" ];

  meta = with lib; {
    description = "Aggregate results from bioinformatics analyses across many samples into a single report";
    homepage = "https://multiqc.info/";
    changelog = "https://github.com/MultiQC/MultiQC/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edmundmiller ];
    mainProgram = "multiqc";
  };
}

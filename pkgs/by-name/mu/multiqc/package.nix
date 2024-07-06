{ lib, python3Packages, fetchPypi, fetchFromGitHub }:

let
  test-data = fetchFromGitHub {
    owner = "MultiQC";
    repo = "test-data";
    rev = "d3e5dc356ef25011287f1ba65605d2ef82bb84e5";
    hash = "sha256-jNom8oMww34xkDqJPdhMTnX7DdPTjesfnVUuCZ2Tz1Q=";
  };
in python3Packages.buildPythonApplication rec {
  version = "1.21";
  pname = "multiqc";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y7yH4lHb94jcyKReWEguoJsm0FlXv1DHfGhNXwlypJU=";
  };

  # Specify dependencies
  propagatedBuildInputs = with python3Packages; [
    click
    coloredlogs
    future
    jinja2
    lzstring
    markdown
    matplotlib
    networkx
    numpy
    plotly
    pyyaml
    requests
    rich
    rich-click
    simplejson
    spectra
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # requires additional data
  pytestFlagsArray = [ "${test-data}" ];

  nativeBuildInputs = with python3Packages; [ importlib-metadata pyaml-env ];

  # html_ids not found
  disabledTests = [ "test_sample_name_cleaning.py" ];

  meta = with lib; {
    mainProgram = "multiqc";
    description =
      "Create a single report with interactive plots for multiple bioinformatics analyses across many samples.";
    homepage = "https://multiqc.info/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ apraga ];
  };
}

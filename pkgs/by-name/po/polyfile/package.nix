{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "polyfile";
  version = "0.5.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-o/hKgfdUWAgLByMk4/2DgEBTvUhidjIhyeyQuJR3YBo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ git ];

  dependencies = with python3Packages; [
    abnf
    chardet
    cint
    fickling
    graphviz
    intervaltree
    jinja2
    kaitaistruct
    networkx
    pdfminer-six
    pillow
    pyyaml
    setuptools
  ];

  build-system = with python3Packages; [ setuptools ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    distutils
  ];

  disabledTestPaths = [
    "tests/test_corkami.py" # requires network
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A utility to recursively map the structure of a file.";
    homepage = "https://github.com/trailofbits/polyfile";
    license = licenses.asl20;
    mainProgram = "polyfile";
    maintainers = with maintainers; [ feyorsh ];
  };
}

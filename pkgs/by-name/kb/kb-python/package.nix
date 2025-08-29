{
  lib,
  python3Packages,
  fetchFromGitHub,
  kallisto,
  bustools,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "kb-python";
  version = "0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "kb_python";
    owner = "pachterlab";
    tag = "v${version}";
    hash = "sha256-3Jlt4oB7zVmQXLjU/2ihcOyj650NCf+2JY/3O4PvC6M=";
  };

  postPatch = ''
    substituteInPlace kb_python/config.py \
      --replace-fail "BUSTOOLS_PATH =" "BUSTOOLS_PATH = \"${lib.getExe bustools}\" #" \
      --replace-fail "KALLISTO_PATH =" "KALLISTO_PATH = \"${lib.getExe kallisto}\" #"

    # Fix test (typo?)
    substituteInPlace tests/dry/test_utils.py \
      --replace-fail "assertEquals" "assertEqual"
  '';

  dependencies = with python3Packages; [
    anndata
    h5py
    jinja2
    loompy
    nbconvert
    nbformat
    ngs-tools
    numpy
    pandas
    plotly
    requests
    scanpy
    scikit-learn
    typing-extensions
    biopython
  ];

  pythonImportsCheck = "kb_python";

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
  ];

  disabledTests = [
    # Fail because we use kallisto/bustools from nix
    "test_set_bustools_binary_path"
    "test_set_bustools_binary_path_in_path"
    "test_set_kallisto_binary_path"
    "test_set_kallisto_binary_path_in_path"

    # Disable tests until upstream fix
    # Mock test should be called with gzip=False argument:
    #   matrix_to_cellranger
    #   filter_with_bustools
    # https://github.com/pachterlab/kb_python/issues/304
    "test_count_cellranger"
    "test_filter_with_bustools_cellranger"
    "test_count_filter"
    "test_count_kite_filter"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wrapper for kallisto and bustools, used for single-cell RNA-seq pre-processing";
    longDescription = ''
      Kallisto | bustools is a workflow for pre-processing
      single-cell RNA-seq data. Pre-processing single-cell RNA-seq involves: (1)
      association of reads with their cells of origin, (2) collapsing of reads
      according to unique molecular identifiers (UMIs), and (3) generation of
      gene or feature counts from the reads to generate a cell x gene matrix
    '';
    mainProgram = "kb";
    downloadPage = "https://github.com/pachterlab/kb_python";
    homepage = "https://www.kallistobus.tools";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.kupac ];
  };
}

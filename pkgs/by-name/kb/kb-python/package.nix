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
  version = "0.29.5";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "kb_python";
    owner = "pachterlab";
    tag = "v${version}";
    hash = "sha256-py4g8iAJZ6Z6fPP/QeCXnDV9U9d8CH8JY/+oXha18tI=";
  };

  postPatch = ''
    substituteInPlace kb_python/config.py \
      --replace-fail "BUSTOOLS_PATH =" "BUSTOOLS_PATH = \"${lib.getExe bustools}\" #" \
      --replace-fail "KALLISTO_PATH =" "KALLISTO_PATH = \"${lib.getExe kallisto}\" #"
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

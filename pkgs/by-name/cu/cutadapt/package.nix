{
  lib,
  python3Packages,
  fetchFromGitHub,

  # update
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "cutadapt";
  version = "5.2";
  pyproject = true;
  build-system = with python3Packages; [
    setuptools
    setuptools-scm
    cython
  ];

  src = fetchFromGitHub {
    owner = "marcelm";
    repo = "cutadapt";
    tag = "v${version}";
    hash = "sha256-CA6wp0By+TivsghR0tWHPvqXdSSvcMCzFOOnrUydKUI=";
  };

  dependencies = with python3Packages; [
    xopen
    dnaio
  ];

  pythonImportsCheck = [ "cutadapt" ];

  preCheck = ''
    # some tests use the executable
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = [
    # the `env` argument of `check_call` deletes PYTHONPATH, so it doesn't
    # find the cutadapt module. Probably nix sandbox specific
    "test_non_utf8_locale"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-mock
    pytest-timeout
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Removes adapters from nucleic acid sequencing reads";
    longDescription = ''
      This bioinformatics tool finds and removes adapter sequences, primers,
      poly-A tails and other types of unwanted sequences from your
      high-throughput sequencing reads in an error-tolerant way.
    '';
    homepage = "https://cutadapt.readthedocs.io";
    downloadPage = "https://github.com/marcelm/cutadapt/tags";
    changelog = "https://cutadapt.readthedocs.io/en/stable/changes.html";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
}

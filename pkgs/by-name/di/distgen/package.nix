{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "distgen";
  version = "2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VG9EX9LHoZamBM3PEm5qGpViK39qD+PA8vcHTzvsW+o=";
  };

  build-system = with python3.pkgs; [
    setuptools
    argparse-manpage
  ];

  dependencies = with python3.pkgs; [
    distro
    jinja2
    six
    pyyaml
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest
    mock
  ];

  checkPhase = ''
    runHook preCheck

    make test-unit PYTHON=${python3.executable}

    runHook postCheck
  '';

  meta = {
    description = "Templating system/generator for distributions";
    mainProgram = "dg";
    license = lib.licenses.gpl2Plus;
    homepage = "https://distgen.readthedocs.io";
    maintainers = with lib.maintainers; [ bachp ];
  };
}

{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "distgen";
  version = "2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-w+/aiLv5NCQFD0ItlC+Wy9BuvA/ndDQcLf6Iyb9trF4=";
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
})

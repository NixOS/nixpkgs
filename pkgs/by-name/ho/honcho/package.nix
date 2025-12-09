{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "honcho";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nickstenning";
    repo = "honcho";
    tag = "v${version}";
    hash = "sha256-hXPoqxK9jzCn7KrQ6zH0E/3YVC60OSoiUx6654+bhhw=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = with python3Packages; [
    jinja2
    pytest
    mock
    coverage
  ];

  # missing plugins
  doCheck = false;

  checkPhase = ''
    runHook preCheck

    PATH=$out/bin:$PATH coverage run -m pytest

    runHook postCheck
  '';

  meta = {
    description = "Python clone of Foreman, a tool for managing Procfile-based applications";
    license = lib.licenses.mit;
    homepage = "https://github.com/nickstenning/honcho";
    maintainers = with lib.maintainers; [ benley ];
    platforms = lib.platforms.unix;
    mainProgram = "honcho";
  };
}

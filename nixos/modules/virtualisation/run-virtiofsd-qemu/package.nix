{
  lib,
  buildPythonApplication,
  virtiofsd,
  ruff,
  setuptools,
  ty,
}:

buildPythonApplication {
  pname = "run-virtiofsd-qemu";
  version = "1.0";
  pyproject = true;

  src = ./.;

  postPatch = ''
    substituteInPlace ./run_virtiofsd_qemu/__init__.py \
      --replace-fail "@virtiofsd@" "${lib.getExe virtiofsd}"
  '';

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    virtiofsd
  ];

  doCheck = true;

  nativeCheckInputs = [
    ruff
    ty
  ];

  checkPhase = ''
    echo -e "\x1b[32m## run ty\x1b[0m"
    ty check --error-on-warning run_virtiofsd_qemu
    echo -e "\x1b[32m## run ruff check\x1b[0m"
    ruff check .
    echo -e "\x1b[32m## run ruff format\x1b[0m"
    ruff format --check --diff .
  '';

  meta = {
    mainProgram = "run-virtiofsd-qemu";
  };
}

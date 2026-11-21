{
  lib,
  python,
  buildPythonApplication,
  setuptools,
  pytest,
  pytest-asyncio,
  ipython,
  ruff,
  ty,
  # TODO: factor out common types from the nixos-test-driver into another package
  # and depend on it here, e.g. exception, duration coercion and logger.
  nixos-test-driver,
  test-thing,
  openssh,
  vhost-device-vsock,
  OVMF,
  qemu_test,
}:

buildPythonApplication {
  pname = "image-test-driver";
  version = "0.1.0";
  pyproject = true;

  src = ./.;

  build-system = [ setuptools ];

  dependencies = [
    nixos-test-driver
    test-thing
    ipython
  ];

  buildInputs = [
    python
    openssh
    vhost-device-vsock
    OVMF.fd
  ];

  passthru.runtimeDependencies = [
    qemu_test
    openssh
    vhost-device-vsock
    OVMF.fd
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    ruff
    ty
  ];

  checkPhase = ''
    runHook preCheck
    echo "## pytest"
    pytest -p no:cacheprovider tests
    echo "## ty"
    PYTHONPATH=".:$PYTHONPATH" ty check image_test_driver
    echo "## ruff check"
    ruff check .
    echo "## ruff format"
    ruff format --check --diff .
    runHook postCheck
  '';

  meta = {
    description = "Async test driver for virtual machine images";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.raitobezarius ];
    mainProgram = "image-test-driver";
  };
}

{
  lib,
  python3Packages,
  enableOCR ? false,
  qemu_pkg ? qemu_test,
  coreutils,
  imagemagick_light,
  netpbm,
  qemu_test,
  socat,
  ruff,
  tesseract4,
  vde2,
  extraPythonPackages ? (_: [ ]),
  nixosTests,
}:

python3Packages.buildPythonApplication {
  pname = "nixos-test-driver";
  version = "1.1";
  pyproject = true;

  src = ./src;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      colorama
      junit-xml
      ptpython
      ipython
      remote-pdb
    ]
    ++ extraPythonPackages python3Packages;

  propagatedBuildInputs = [
    coreutils
    netpbm
    qemu_pkg
    socat
    vde2
  ]
  ++ lib.optionals enableOCR [
    imagemagick_light
    tesseract4
  ];

  passthru.tests = {
    inherit (nixosTests.nixos-test-driver) driver-timeout;
  };

  doCheck = true;

  nativeCheckInputs = with python3Packages; [
    mypy
    ruff
  ];

  checkPhase = ''
    echo -e "\x1b[32m## run mypy\x1b[0m"
    mypy test_driver extract-docstrings.py
    echo -e "\x1b[32m## run ruff check\x1b[0m"
    ruff check .
    echo -e "\x1b[32m## run ruff format\x1b[0m"
    ruff format --check --diff .
  '';
}

{
  lib,
<<<<<<< HEAD

  buildPythonApplication,
  colorama,
  coreutils,
  imagemagick_light,
  ipython,
  junit-xml,
  mypy,
  ptpython,
  python,
  ruff,
  remote-pdb,

  netpbm,
  nixosTests,
  qemu_pkg ? qemu_test,
  qemu_test,
  setuptools,
  socat,
  tesseract4,
  vde2,

  enableOCR ? false,
  extraPythonPackages ? (_: [ ]),
}:

buildPythonApplication {
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "nixos-test-driver";
  version = "1.1";
  pyproject = true;

  src = ./src;

<<<<<<< HEAD
  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    ipython
    junit-xml
    ptpython
    remote-pdb
  ]
  ++ extraPythonPackages python.pkgs;
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  nativeCheckInputs = [
=======
  nativeCheckInputs = with python3Packages; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

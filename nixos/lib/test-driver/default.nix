{
  lib,

  buildPythonApplication,
  colorama,
  coreutils,
  imagemagick_light,
  ipython,
  junit-xml,
  ptpython,
  python,
  remote-pdb,
  ruff,
  ty,

  netpbm,
  nixosTests,
  qemu_pkg ? qemu_test,
  qemu_test,
  setuptools,
  socat,
  systemd,
  tesseract4,
  util-linux,
  vde2,

  enableNspawn ? false,
  enableOCR ? false,
  extraPythonPackages ? (_: [ ]),
}:

buildPythonApplication {
  pname = "nixos-test-driver";
  version = "1.1";
  pyproject = true;

  src = ./src;

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

  propagatedBuildInputs = [
    coreutils
    netpbm
    qemu_pkg
    socat
    util-linux
    vde2
  ]
  ++ lib.optionals enableNspawn [
    systemd
  ]
  ++ lib.optionals enableOCR [
    imagemagick_light
    tesseract4
  ];

  passthru.tests = {
    inherit (nixosTests.nixos-test-driver) driver-timeout;
  };

  doCheck = true;

  nativeCheckInputs = [
    ruff
    ty
  ];

  checkPhase = ''
    echo -e "\x1b[32m## run ty\x1b[0m"
    ty check --error-on-warning test_driver extract-docstrings.py
    echo -e "\x1b[32m## run ruff check\x1b[0m"
    ruff check .
    echo -e "\x1b[32m## run ruff format\x1b[0m"
    ruff format --check --diff .
  '';
}

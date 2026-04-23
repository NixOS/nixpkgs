{
  lib,

  buildPythonApplication,
  colorama,
  coreutils,
  imagemagick_light,
  ipython,
  junit-xml,
  ptpython,
  pydantic,
  python,
  remote-pdb,
  ruff,
  ty,

  iproute2,
  netpbm,
  vhost-device-vsock,
  nixosTests,
  qemu_pkg ? qemu_test,
  qemu_test,
  setuptools,
  socat,
  systemd,
  tesseract4,
  util-linux,
  vde2,
  vde_plug2tapless,

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
    pydantic
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
    iproute2
    vde_plug2tapless
    vhost-device-vsock
  ]
  ++ lib.optionals enableNspawn [
    systemd
  ]
  ++ lib.optionals enableOCR [
    imagemagick_light
    tesseract4
  ];

  # containers test requires extra nix features that are not available in ofborg.
  passthru.tests = removeAttrs nixosTests.nixos-test-driver [ "containers" ];

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

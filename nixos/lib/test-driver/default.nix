{
  lib,
  stdenv,

  buildPythonApplication,
  colorama,
  coreutils,
  imagemagick_light,
  ipython,
  junit-xml,
  ptpython,
  pydantic,
  python,
  pythonOlder,
  ovmfvartool,
  remote-pdb,
  ruff,
  ty,

  netpbm,
  vhost-device-vsock,
  nixosTests,
  setuptools,
  socat,
  systemd,
  tesseract4,
  util-linux,
  vde2,

  enableNspawn ? false,
  enableOCR ? false,
  enableRuntimeDeps ? true,
  extraPythonPackages ? (_: [ ]),
}:

buildPythonApplication {
  pname = "nixos-test-driver";
  version = "1.1";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = ./src;

  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    junit-xml
    pydantic
    ovmfvartool
    remote-pdb
  ]
  ++ lib.optionals enableRuntimeDeps [
    ipython
    ptpython
  ]
  ++ extraPythonPackages python.pkgs;

  propagatedBuildInputs = [
    coreutils
  ]
  ++ lib.optionals enableRuntimeDeps (
    [
      netpbm
      socat
      util-linux
      vde2
    ]
    ++ lib.optionals stdenv.isLinux [
      vhost-device-vsock
    ]
  )
  ++ lib.optionals enableNspawn [
    systemd
  ]
  ++ lib.optionals enableOCR [
    imagemagick_light
    tesseract4
  ];

  # containers test requires extra nix features that are not available in ofborg.
  passthru.tests = removeAttrs nixosTests.nixos-test-driver [ "containers" ];

  doCheck = enableRuntimeDeps;

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

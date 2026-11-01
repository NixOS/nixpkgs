{
  lib,
  stdenv,

  python3Packages,
  coreutils,
  imagemagick_light,
  libtiff,

  netpbm,
  vhost-device-vsock,
  nixosTests,
  socat,
  systemd,
  tesseract4,
  util-linux,
  vde2,

  enableNspawn ? false,
  enableOCR ? false,
  extraPythonPackages ? (_: [ ]),
}:

let
  imagemagick_light = imagemagick_light.override { inherit libtiff; };
  tesseract4 = tesseract4.override { enableLanguages = [ "eng" ]; };
in
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
      ipython
      junit-xml
      ptpython
      pydantic
      ovmfvartool
      remote-pdb
    ]
    ++ extraPythonPackages python3Packages;

  propagatedBuildInputs = [
    coreutils
    netpbm
    socat
    util-linux
    vde2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    vhost-device-vsock
  ]
  ++ lib.optionals enableNspawn [
    systemd
  ]
  ++ lib.optionals enableOCR [
    imagemagick_light
    tesseract4
  ];

  # containers tests require extra nix features that are not available in ofborg.
  passthru.tests = removeAttrs nixosTests.nixos-test-driver [
    "containers"
    "nspawn-interactive"
  ];

  doCheck = true;

  nativeCheckInputs = with python3Packages; [
    ruff
    ty
  ];

  checkPhase = ''
    echo -e "\x1b[32m## run ty\x1b[0m"
    # Installation adds the driver to PYTHONPATH; keep ty imports in the source tree.
    PYTHONPATH=".:$PYTHONPATH" ty check --error-on-warning test_driver extract-docstrings.py
    echo -e "\x1b[32m## run ruff check\x1b[0m"
    ruff check .
    echo -e "\x1b[32m## run ruff format\x1b[0m"
    ruff format --check --diff .
  '';

  meta.license = lib.licenses.mit;
}

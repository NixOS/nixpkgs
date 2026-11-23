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
  pytest,
  python,
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
    ovmfvartool
    remote-pdb
  ]
  ++ extraPythonPackages python.pkgs;

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
  passthru = {
    tests = removeAttrs nixosTests.nixos-test-driver [
      "containers"
      "nspawn-interactive"
    ];

    # Not only test-driver specific things, but also tests verifying
    # correct integration with other components of the test-driver stack, most
    # notably virtualisation.qemu.
    # Intended to have a simple way as maintainer to verify that features didn't regress
    # without intimate knowledge which tests make use of which features.
    qa = lib.recurseIntoAttrs {
      inherit (nixosTests)
        credentials-smbios
        qemu-vm-shared-directories
        qemu-vm-external-disk-image
        ;

      nixos-test-driver = lib.recurseIntoAttrs nixosTests.nixos-test-driver;
    };
  };

  doCheck = true;

  nativeCheckInputs = [
    pytest
    ruff
    ty
  ];

  checkPhase = ''
    echo -e "\x1b[32m## run tests\x1b[0m"
    pytest --doctest-modules -p no:cacheprovider test_driver tests
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

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
let
  fs = lib.fileset;
in
python3Packages.buildPythonApplication {
  pname = "nixos-test-driver";
  version = "1.1";
  src = fs.toSource {
    root = ./.;
    fileset = fs.unions [
      ./pyproject.toml
      ./test_driver
      ./extract-docstrings.py
    ];
  };
  pyproject = true;

  propagatedBuildInputs =
    [
      coreutils
      netpbm
      python3Packages.colorama
      python3Packages.junit-xml
      python3Packages.ptpython
      qemu_pkg
      socat
      vde2
    ]
    ++ (lib.optionals enableOCR [
      imagemagick_light
      tesseract4
    ])
    ++ extraPythonPackages python3Packages;

  nativeBuildInputs = [
    python3Packages.setuptools
  ];

  passthru.tests = {
    inherit (nixosTests.nixos-test-driver) driver-timeout;
  };

  doCheck = true;
  nativeCheckInputs = with python3Packages; [
    mypy
    ruff
    black
  ];
  checkPhase = ''
    echo -e "\x1b[32m## run mypy\x1b[0m"
    mypy test_driver extract-docstrings.py
    echo -e "\x1b[32m## run ruff\x1b[0m"
    ruff check .
    echo -e "\x1b[32m## run black\x1b[0m"
    black --check --diff .
  '';
}

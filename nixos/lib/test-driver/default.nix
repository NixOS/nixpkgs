{ lib
, python3Packages
, enableOCR ? false
, qemu_pkg ? qemu_test
, coreutils
, imagemagick_light
, libtiff
, netpbm
, qemu_test
, socat
, tesseract4
, vde2
, extraPythonPackages ? (_ : [])
}:

python3Packages.buildPythonApplication rec {
  pname = "nixos-test-driver";
  version = "1.1";
  src = ./.;

  propagatedBuildInputs = [
    coreutils
    netpbm
    python3Packages.colorama
    python3Packages.ptpython
    qemu_pkg
    socat
    vde2
  ]
    ++ (lib.optionals enableOCR [ imagemagick_light tesseract4 ])
    ++ extraPythonPackages python3Packages;

  doCheck = true;
  nativeCheckInputs = with python3Packages; [ mypy pylint black ];
  checkPhase = ''
    mypy --disallow-untyped-defs \
          --no-implicit-optional \
          --pretty \
          --no-color-output \
          --ignore-missing-imports ${src}/test_driver
    pylint --errors-only --enable=unused-import ${src}/test_driver
    black --check --diff ${src}/test_driver
  '';
}

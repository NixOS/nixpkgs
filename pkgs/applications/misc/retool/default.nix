{ lib
, stdenv
, python3
, fetchFromGitHub
, qt6
}:

python3.pkgs.buildPythonApplication {
  pname = "retool";
  version = "unstable-2023-08-24";

  format = "pyproject";
  disabled = python3.pkgs.pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "unexpectedpanda";
    repo = "retool";
    rev =  "d8acdb960d35b5a6b01d7dc66b7e40b3ec451301";
    hash = "sha256-6y/7RR7O2xYKXdxaFtkRfnSlwygp/LRDUozUJo6ue7s=";
  };

  patches = [
    # pythonRelaxDepsHook will not work in this package until
    # https://github.com/NixOS/nixpkgs/pull/248516 hits master
    ./relax_deps.patch
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ] ++
  lib.optionals (stdenv.isLinux) [
    qt6.qtwayland
  ];

  propagatedBuildInputs = with python3.pkgs; [
    alive-progress
    lxml
    psutil
    validators
    pyside6
    strictyaml
  ];

  # Upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "A better filter tool for Redump and No-Intro dats";
    homepage = "https://github.com/unexpectedpanda/retool";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thiagokokada ];
  };
}

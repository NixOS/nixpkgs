{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  okonomiyaki,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "simplesat";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "sat-solver";
    rev = "refs/tags/v${version}";
    hash = "sha256-/fBnpf1DtaF+wQYZztcB8Y20/ZMYxrF3fH5qRsMucL0=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "version = file: VERSION" "version = ${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [
    attrs
    okonomiyaki
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "simplesat" ];

  preCheck = ''
    substituteInPlace simplesat/tests/test_pool.py \
      --replace-fail "assertRaisesRegexp" "assertRaisesRegex"
  '';

  pytestFlagsArray = [ "simplesat/tests" ];

  meta = with lib; {
    description = "Prototype for SAT-based dependency handling";
    homepage = "https://github.com/enthought/sat-solver";
    changelog = "https://github.com/enthought/sat-solver/blob/v${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ genericnerdyusername ];
  };
}

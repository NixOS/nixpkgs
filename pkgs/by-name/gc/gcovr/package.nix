{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "gcovr";
  version = "8.3";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+qNx+cSn94yYANplUQfU+Z8EtxjRwNn0jK/cvvAEkHk=";
  };

  build-system = [ python3Packages.hatchling ];

  # pythonRelaxDeps do not work on pyproject.toml
  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.1" "hatchling"
    substituteInPlace pyproject.toml \
      --replace-fail "hatch-fancy-pypi-readme==24.1.0" "hatch-fancy-pypi-readme>=24.1.0"
    substituteInPlace pyproject.toml \
      --replace-fail "hatch-vcs==0.4.0" "hatch-vcs>=0.4.0"
  '';

  dependencies =
    with python3Packages;
    (
      [
        colorlog
        jinja2
        lxml
        pygments
        hatch-fancy-pypi-readme
        hatch-vcs
      ]
      ++ lib.optionals (pythonOlder "3.11") [ tomli ]
    );

  # There are no unit tests in the pypi tarball. Most of the unit tests on the
  # github repository currently only work with gcc5, so we just disable them.
  # See also: https://github.com/gcovr/gcovr/issues/206
  # Despite the CI passing many GCC version, ~300 tests are failing on nixos
  doCheck = false;

  pythonImportsCheck = [
    "gcovr"
    "gcovr.configuration"
  ];

  meta = {
    description = "Python script for summarizing gcov data";
    homepage = "https://www.gcovr.com/";
    changelog = "https://github.com/gcovr/gcovr/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "gcovr";
  };
}

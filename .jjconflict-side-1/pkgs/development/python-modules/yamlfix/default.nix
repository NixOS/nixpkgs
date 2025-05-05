{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  maison,
  pdm-backend,
  pytest-freezegun,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  ruyaml,
  setuptools,
}:
let
  maison143 = maison.overridePythonAttrs (old: rec {
    version = "1.4.3";
    src = fetchFromGitHub {
      owner = "dbatten5";
      repo = "maison";
      tag = "v${version}";
      hash = "sha256-2hUmk91wr5o2cV3un2nMoXDG+3GT7SaIOKY+QaZY3nw=";
    };
  });
in

buildPythonPackage rec {
  pname = "yamlfix";
  version = "1.16.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = "yamlfix";
    tag = version;
    hash = "sha256-nadyBIzXHbWm0QvympRaYU38tuPJ3TPJg8EbvVv+4L0=";
  };

  build-system = [
    setuptools
    pdm-backend
  ];

  dependencies = [
    click
    maison143
    ruyaml
  ];

  nativeCheckInputs = [
    pytest-freezegun
    pytest-xdist
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "yamlfix" ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ koozz ];
  };
}

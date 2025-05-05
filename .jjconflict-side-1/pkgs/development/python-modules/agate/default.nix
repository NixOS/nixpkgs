{
  lib,
  babel,
  buildPythonPackage,
  cssselect,
  fetchFromGitHub,
  glibcLocales,
  isodate,
  leather,
  lxml,
  parsedatetime,
  pyicu,
  pytestCheckHook,
  python-slugify,
  pythonOlder,
  pytimeparse,
  setuptools,
}:

buildPythonPackage rec {
  pname = "agate";
  version = "1.13.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "wireservice";
    repo = "agate";
    tag = version;
    hash = "sha256-jDeme5eOuX9aQ+4A/pLnH/SuCOztyZzKdSBYKVC63Bk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    babel
    isodate
    leather
    parsedatetime
    python-slugify
    pytimeparse
  ];

  nativeCheckInputs = [
    cssselect
    glibcLocales
    lxml
    pyicu
    pytestCheckHook
  ];

  pythonImportsCheck = [ "agate" ];

  meta = {
    description = "Python data analysis library that is optimized for humans instead of machines";
    homepage = "https://github.com/wireservice/agate";
    changelog = "https://github.com/wireservice/agate/blob/${version}/CHANGELOG.rst";
    license = with lib.licenses; [ mit ];
    maintainers = [ ];
  };
}

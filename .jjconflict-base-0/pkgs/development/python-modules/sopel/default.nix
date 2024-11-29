{
  lib,
  buildPythonPackage,
  dnspython,
  fetchPypi,
  geoip2,
  ipython,
  isPyPy,
  setuptools,
  praw,
  pyenchant,
  pytestCheckHook,
  pythonOlder,
  pytz,
  sqlalchemy,
  xmltodict,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "sopel";
  version = "8.0.0";
  pyproject = true;

  disabled = isPyPy || pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-juLJp0Et5qMZwBZzw0e4tKg1cBYqAsH8KUzqNoIP70U=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=66.1" "setuptools"
  '';

  dependencies = [
    dnspython
    geoip2
    ipython
    praw
    pyenchant
    pytz
    sqlalchemy
    xmltodict
    importlib-metadata
  ];

  pythonRemoveDeps = [ "sopel-help" ];

  pythonRelaxDeps = [ "sqlalchemy" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # requires network access
    "test_example_exchange_cmd_0"
    "test_example_exchange_cmd_1"
    "test_example_duck_0"
    "test_example_duck_1"
    "test_example_suggest_0"
    "test_example_suggest_1"
    "test_example_suggest_2"
    "test_example_tr2_0"
    "test_example_tr2_1"
    "test_example_tr2_2"
    "test_example_title_command_0"
    "test_example_wiktionary_0"
    "test_example_wiktionary_ety_0"
  ];

  pythonImportsCheck = [ "sopel" ];

  meta = with lib; {
    description = "Simple and extensible IRC bot";
    homepage = "https://sopel.chat";
    license = licenses.efl20;
    maintainers = with maintainers; [ mog ];
  };
}

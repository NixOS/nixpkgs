{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  altair,
  cryptography,
  jinja2,
  jsonschema,
  marshmallow,
  mistune,
  numpy,
  packaging,
  pandas,
  posthog,
  pydantic,
  pyparsing,
  python-dateutil,
  requests,
  ruamel-yaml,
  scipy,
  tqdm,
  tzlocal,

  # test
  pytestCheckHook,
  pytest-mock,
  pytest-order,
  pytest-random-order,
  click,
  flaky,
  freezegun,
  invoke,
  moto,
  psycopg2,
  requirements-parser,
  responses,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "great-expectations";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "great-expectations";
    repo = "great_expectations";
    rev = "refs/tags/${version}";
    hash = "sha256-TV07vmc0XdP6ICv7Kws79zACCsahZ6FlhplJHbpDFNk=";
  };

  postPatch = ''
    substituteInPlace tests/conftest.py --replace 'locale.setlocale(locale.LC_ALL, "en_US.UTF-8")' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    altair
    cryptography
    jinja2
    jsonschema
    marshmallow
    mistune
    numpy
    packaging
    pandas
    posthog
    pydantic
    pyparsing
    python-dateutil
    requests
    ruamel-yaml
    scipy
    tqdm
    tzlocal
  ];

  pythonRelaxDeps = [
    "altair"
    "pandas"
    "posthog"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pytest-order
    pytest-random-order
    click
    flaky
    freezegun
    invoke
    moto
    psycopg2
    requirements-parser
    responses
    sqlalchemy
  ] ++ moto.optional-dependencies.s3 ++ moto.optional-dependencies.sns;

  disabledTestPaths = [
    # try to access external URLs:
    "tests/integration/cloud/rest_contracts"
    "tests/integration/spark"

    # moto-related import errors:
    "tests/actions"
    "tests/data_context"
    "tests/datasource"
    "tests/execution_engine"

    # locale-related rendering issues, mostly:
    "tests/core/test__docs_decorators.py"
    "tests/expectations/test_expectation_atomic_renderers.py"
    "tests/render"
  ];

  disabledTests = [
    # tries to access network:
    "test_checkpoint_run_with_data_docs_and_slack_actions_emit_page_links"
    "test_checkpoint_run_with_slack_action_no_page_links"
  ];

  pythonImportsCheck = [ "great_expectations" ];
  pytestFlagsArray = [ "-m 'not spark and not postgresql and not snowflake'" ];

  meta = {
    description = "Library for writing unit tests for data validation";
    homepage = "https://docs.greatexpectations.io";
    changelog = "https://github.com/great-expectations/great_expectations/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}

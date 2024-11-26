{
  lib,
  attrs,
  buildPythonPackage,
  bson,
  boto3,
  botocore,
  cattrs,
  fetchFromGitHub,
  itsdangerous,
  platformdirs,
  poetry-core,
  psutil,
  pymongo,
  pytestCheckHook,
  pytest-rerunfailures,
  pytest-xdist,
  pythonOlder,
  pyyaml,
  redis,
  requests,
  requests-mock,
  responses,
  rich,
  tenacity,
  time-machine,
  timeout-decorator,
  ujson,
  urllib3,
  url-normalize,
}:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "requests-cache";
    repo = "requests-cache";
    rev = "refs/tags/v${version}";
    hash = "sha256-juRCcBUr+Ko6kVPpUapwRbUGqWLKaRiCqppOc3S5FMU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    attrs
    cattrs
    platformdirs
    requests
    urllib3
    url-normalize
  ];

  optional-dependencies = {
    dynamodb = [
      boto3
      botocore
    ];
    mongodbo = [ pymongo ];
    redis = [ redis ];
    bson = [ bson ];
    json = [ ujson ];
    security = [ itsdangerous ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs =
    [
      psutil
      pytestCheckHook
      pytest-rerunfailures
      pytest-xdist
      requests-mock
      responses
      rich
      tenacity
      time-machine
      timeout-decorator
    ]
    ++ optional-dependencies.json
    ++ optional-dependencies.security;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    # Integration tests require local DBs
    "tests/unit"
  ];

  disabledTests = [
    # Tests are flaky in the sandbox
    "test_remove_expired_responses"
    # Tests that broke with urllib 2.0.5
    "test_request_only_if_cached__stale_if_error__expired"
    "test_stale_if_error__error_code"
  ];

  pythonImportsCheck = [ "requests_cache" ];

  meta = with lib; {
    description = "Persistent cache for requests library";
    homepage = "https://github.com/reclosedev/requests-cache";
    changelog = "https://github.com/requests-cache/requests-cache/blob/v${version}/HISTORY.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

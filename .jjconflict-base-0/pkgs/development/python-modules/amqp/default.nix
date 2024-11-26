{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-rerunfailures,
  pythonOlder,
  vine,
}:

buildPythonPackage rec {
  pname = "amqp";
  version = "5.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ET5mMQai+wEjyQMNQr85WbliSSg/8UI6sH9crQYtNvc=";
  };

  propagatedBuildInputs = [ vine ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ];

  disabledTests =
    [
      # Requires network access
      "test_rmq.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Requires network access but fails on macos only
      "test_connection.py"
    ];

  pythonImportsCheck = [ "amqp" ];

  meta = with lib; {
    description = "Python client for the Advanced Message Queuing Procotol (AMQP). This is a fork of amqplib which is maintained by the Celery project";
    homepage = "https://github.com/celery/py-amqp";
    changelog = "https://github.com/celery/py-amqp/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}

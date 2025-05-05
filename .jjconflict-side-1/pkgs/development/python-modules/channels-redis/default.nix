{
  lib,
  asgiref,
  buildPythonPackage,
  channels,
  cryptography,
  fetchFromGitHub,
  msgpack,
  pythonOlder,
  redis,
  setuptools,
}:

buildPythonPackage rec {
  pname = "channels-redis";
  version = "4.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django";
    repo = "channels_redis";
    tag = version;
    hash = "sha256-jQkpuOQNU2KCWavXSE/n8gdpQhhAafQbZYfbX71Rcds=";
  };

  build-system = [ setuptools ];

  dependencies = [
    redis
    asgiref
    channels
    msgpack
  ];

  optional-dependencies = {
    cryptography = [ cryptography ];
  };

  # Fails with : ConnectionRefusedError: [Errno 111] Connect call failed ('127.0.0.1', 6379)
  # (even with a local Redis instance running)
  doCheck = false;

  pythonImportsCheck = [ "channels_redis" ];

  meta = with lib; {
    description = "Redis-backed ASGI channel layer implementation";
    homepage = "https://github.com/django/channels_redis/";
    changelog = "https://github.com/django/channels_redis/blob/${version}/CHANGELOG.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

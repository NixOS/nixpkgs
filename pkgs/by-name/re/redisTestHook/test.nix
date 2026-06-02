{
  valkey,
  redisTestHook,
  stdenv,
}:

stdenv.mkDerivation {
  name = "redis-test-hook-test";

  nativeCheckInputs = [
    valkey
    redisTestHook
  ];

  dontUnpack = true;
  doCheck = true;

  preCheck = ''
    redisTestPort=6380
    REDIS_SOCKET=/tmp/customredis.sock
  '';

  checkPhase = ''
    runHook preCheck

    echo "running test"
    if redis-cli --scan -p $redisTestPort; then
      echo "connected to redis via localhost"
      PORT_TEST_RAN=1
    fi

    if redis-cli --scan -s $REDIS_SOCKET; then
      echo "connected to redis via domain socket"
      SOCKET_TEST_RAN=1
    fi

    runHook postCheck
  '';

  installPhase = ''
    [[ $PORT_TEST_RAN == 1 && $SOCKET_TEST_RAN == 1 ]]
    echo "test passed"
    touch $out
  '';

  __darwinAllowLocalNetworking = true;
}

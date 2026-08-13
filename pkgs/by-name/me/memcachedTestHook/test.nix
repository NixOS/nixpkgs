{
  memcachedTestHook,
  netcat,
  stdenv,
}:

stdenv.mkDerivation {
  name = "memcached-test-hook-test";

  nativeCheckInputs = [
    memcachedTestHook
    netcat
  ];

  dontUnpack = true;
  doCheck = true;

  preCheck = ''
    memcachedTestPort=11212
  '';

  checkPhase = ''
    runHook preCheck

    echo "running test"
    if echo -e "stats\nquit" | nc localhost $memcachedTestPort; then
      echo "connected to memcached"
      TEST_RAN=1
    fi

    runHook postCheck
  '';

  __darwinAllowLocalNetworking = true;

  installPhase = ''
    [[ $TEST_RAN == 1 ]]
    echo "test passed"
    touch $out
  '';
}

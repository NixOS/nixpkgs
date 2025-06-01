{
  cassandra,
  cassandraTestHook,
  stdenv,
}:

stdenv.mkDerivation {
  name = "cassandra-test-hook-test";
  buildInputs = [ cassandraTestHook ];
  nativeCheckInputs = [ cassandra ];
  dontUnpack = true;
  doCheck = true;
  cassandraTestSetupPost = ''
    TEST_POST_HOOK_RAN=1
  '';
  checkPhase = ''
    runHook preCheck
    cqlsh -e "CREATE KEYSPACE IF NOT EXISTS testks WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1}; USE testks; CREATE TABLE IF NOT EXISTS hello (id UUID PRIMARY KEY, message TEXT); INSERT INTO hello (id, message) VALUES (uuid(), 'it ' + 'worked'); SELECT * FROM hello;" 127.0.0.1
    TEST_RAN=1
    runHook postCheck
  '';
  installPhase = ''
    [[ $TEST_RAN == 1 && $TEST_POST_HOOK_RAN == 1 ]]
    touch $out
  '';
}

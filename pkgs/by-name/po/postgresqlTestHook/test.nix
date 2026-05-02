{
  postgresql,
  postgresqlTestHook,
  stdenv,
}:

stdenv.mkDerivation {
  name = "postgresql-test-hook-test";
  buildInputs = [ postgresqlTestHook ];
  nativeCheckInputs = [ postgresql ];
  dontUnpack = true;
  doCheck = true;
  sql = ''
    CREATE TABLE hello (
      message text
    );
    INSERT INTO hello VALUES ('it '||'worked');
    SELECT * FROM hello;
  '';
  postgresqlTestSetupPost = ''
    TEST_POST_HOOK_RAN=1
  '';
  checkPhase = ''
    runHook preCheck
    sqlPath=$TMPDIR/test.sql
    printf "%s" "$sql" > $sqlPath
    psql <$sqlPath | grep 'it worked'
    TEST_RAN=1
    runHook postCheck
  '';
  installPhase = ''
    [[ $TEST_RAN == 1 && $TEST_POST_HOOK_RAN == 1 ]]
    touch $out
  '';
  __structuredAttrs = true;
}

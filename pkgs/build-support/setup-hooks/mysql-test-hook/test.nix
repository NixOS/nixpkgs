{ mariadb, mysqlTestHook, stdenv }:

stdenv.mkDerivation {
  name = "mysql-test-hook-test";
  buildInputs = [ mysqlTestHook ];
  nativeCheckInputs = [ mariadb ];
  dontUnpack = true;
  doCheck = true;
  passAsFile = ["sql"];
  sql = ''
    CREATE TABLE hello (
      message text
    );
    INSERT INTO hello VALUES ('it worked');
    SELECT * FROM hello;
  '';
  mysqlTestSetupPost = ''
    TEST_POST_HOOK_RAN=1
  '';
  checkPhase = ''
    runHook preCheck
    cat $sqlPath | mysql $MYSQL_DATABASE | grep 'it worked'
    TEST_RAN=1
    runHook postCheck
  '';
  installPhase = ''
    [[ $TEST_RAN == 1 && $TEST_POST_HOOK_RAN == 1 ]]
    touch $out
  '';
}

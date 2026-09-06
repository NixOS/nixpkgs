{ runCommand, passhole }:

runCommand "passhole-basic-test"
  {
    nativeBuildInputs = [ passhole ];

    expectedList = "mypass\n";
    expectedPassword = "pword";
    expectedUsername = "uname";
  }
  ''
    mkdir $out/

    # Setup the database with a single password
    passhole --config ./config.ini init --database ./db.kdbx --keyfile ./keyfile.txt --name test-database
    echo -e 'uname\npword\npword\nhttps://example.com\n\n' | passhole --config ./config.ini --no-password add mypass

    # Test the database
    passhole --config ./config.ini list > $out/list.txt
    passhole --config ./config.ini show mypass --field password > $out/password.txt
    passhole --config ./config.ini show mypass --field username > $out/username.txt

    # Check that the output was correct
    cmp $out/list.txt <(echo -n "$expectedList")
    cmp $out/password.txt <(echo -n "$expectedPassword")
    cmp $out/username.txt <(echo -n "$expectedUsername")
  ''

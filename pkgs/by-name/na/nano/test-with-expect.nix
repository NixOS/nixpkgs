{
  nano,
  expect,
  runCommand,
  writeScriptBin,
}:

let
  expect-script = writeScriptBin "expect-script" ''
    #!${expect}/bin/expect -f

    # Load nano
    spawn nano file.txt
    expect "GNU nano ${nano.version}"

    # Add some text to the buffer
    send "Hello world!"
    expect "Hello world!"

    # Send ctrl-x (exit)
    send "\030"
    expect "Save modified buffer?"

    # Answer "yes"
    send "y"
    expect "File Name to Write"

    # Send "return" to accept the file path.
    send "\r"
    sleep 1
    exit
  '';
in
runCommand "nano-test-expect"
  {
    nativeBuildInputs = [
      nano
      expect
    ];
    passthru = { inherit expect-script; };
  }
  ''
    expect -f ${expect-script}/bin/expect-script
    grep "Hello world!" file.txt
    touch $out
  ''

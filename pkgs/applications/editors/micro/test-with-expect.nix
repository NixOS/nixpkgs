{
  micro,
  expect,
  runCommand,
  writeScript,
  runtimeShell,
}:

let
  expect-script = writeScript "expect-script" ''
    #!${expect}/bin/expect -f

    spawn micro file.txt
    expect "file.txt"

    send "Hello world!"
    expect "Hello world!"

    # Send ctrl-q (exit)
    send "\021"

    expect "Save changes to file.txt before closing?"
    send "y"

    expect eof
  '';
in
runCommand "micro-test-expect"
  {
    nativeBuildInputs = [
      micro
      expect
    ];
    passthru = { inherit expect-script; };
  }
  ''
    # Micro really wants a writable $HOME for its config directory.
    export HOME=$(pwd)
    expect -f ${expect-script}
    grep "Hello world!" file.txt
    touch $out
  ''

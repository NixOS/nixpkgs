{
  expect,
  micro,
  runCommand,
}:

let
  expect-script = builtins.path {
    name = "hello.tcl";
    path = ./hello.tcl;
  };
in
runCommand "micro-expect-hello-world"
  {
    nativeBuildInputs = [
      expect
      micro
    ];
  }
  # Micro needs a writable $HOME for throwing its configuration
  ''
    export HOME=$(pwd)
    expect -f ${expect-script}
    grep "Hello world!" file.txt
    cat file.txt > $out
  ''

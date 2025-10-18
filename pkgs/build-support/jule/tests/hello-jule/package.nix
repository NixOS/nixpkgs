{ buildJuleModule, runCommand }:

let
  testModule = buildJuleModule {
    pname = "hello-jule";
    version = "0.0.1";
    src = ./.;
    srcDir = ".";
    meta.mainProgram = "hello-jule";
  };
in
runCommand "hello-jule-test" { } ''
  set -e
  output=$(${testModule}/bin/hello-jule)

  if [ "$output" != "Hello, Jule!" ]; then
    echo "Test failed: expected 'Hello, Jule!' but got '$output'"
    exit 1
  fi

  echo "ok" > "$out"
''

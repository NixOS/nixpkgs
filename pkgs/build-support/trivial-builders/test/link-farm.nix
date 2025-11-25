{
  linkFarm,
  hello,
  writeTextFile,
  runCommand,
}:
let
  foo = writeTextFile {
    name = "foo";
    text = "foo";
  };

  linkFarmFromList = linkFarm "linkFarmFromList" [
    {
      name = "foo";
      path = foo;
    }
    {
      name = "hello";
      path = hello;
    }
  ];

  linkFarmWithRepeats = linkFarm "linkFarmWithRepeats" [
    {
      name = "foo";
      path = foo;
    }
    {
      name = "hello";
      path = hello;
    }
    {
      name = "foo";
      path = hello;
    }
  ];

  linkFarmFromAttrs = linkFarm "linkFarmFromAttrs" {
    inherit foo hello;
  };

  linkFarmDelimitOptionList = linkFarm "linkFarmDelimitOptionList" {
    "-foo" = foo;
    "-hello" = hello;
  };
in
runCommand "test-linkFarm" { } ''
  function assertPathEquals() {
    local a b;
    a="$(realpath "$1")"
    b="$(realpath "$2")"
    if [ "$a" != "$b" ]; then
      echo "path mismatch!"
      echo "a: $1 -> $a"
      echo "b: $2 -> $b"
      exit 1
    fi
  }

  assertPathEquals "${linkFarmFromList}/foo" "${foo}"
  assertPathEquals "${linkFarmFromList}/hello" "${hello}"

  assertPathEquals "${linkFarmWithRepeats}/foo" "${hello}"
  assertPathEquals "${linkFarmWithRepeats}/hello" "${hello}"

  assertPathEquals "${linkFarmFromAttrs}/foo" "${foo}"
  assertPathEquals "${linkFarmFromAttrs}/hello" "${hello}"

  assertPathEquals "${linkFarmDelimitOptionList}/-foo" "${foo}"
  assertPathEquals "${linkFarmDelimitOptionList}/-hello" "${hello}"

  touch $out
''

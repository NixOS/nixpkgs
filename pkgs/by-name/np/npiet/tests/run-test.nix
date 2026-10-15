{
  runCommand,
  lib,
  npiet,

  testName,
  programPath,
  programInput ? "",
  expectedOutput,
}:
runCommand "npiet-test-${testName}" { } ''
  actual_output="$(echo '${programInput}' | '${lib.getExe npiet}' -q -w -e 100000 '${programPath}')"
  if [ "$actual_output" != '${expectedOutput}' ]; then
    echo "npiet failed to run the program correctly. The output should be ${expectedOutput} but is $actual_output."
    exit 1
  fi
  echo "The program successfully output $actual_output"
  touch "$out"
''

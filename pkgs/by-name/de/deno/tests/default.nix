{
  deno,
  runCommand,
  lib,
  testers,
}:
let
  testDenoRun =
    name:
    {
      args ? "",
      dir ? ./. + "/${name}",
      file ? "index.ts",
      expected ? "",
      expectFailure ? false,
    }:
    let
      command = "deno run ${args} ${dir}/${file}";
    in
    runCommand "deno-test-${name}"
      {
        nativeBuildInputs = [ deno ];
        meta.timeout = 60;
      }
      ''
        HOME=$(mktemp -d)
        if output=$(${command} 2>&1); then
          if [[ $output =~ '${expected}' ]]; then
            echo "Test '${name}' passed"
            touch $out
          else
            echo -n ${lib.escapeShellArg command} >&2
            echo " output did not match what was expected." >&2
            echo "The expected was:" >&2
            echo '${expected}' >&2
            echo "The output was:" >&2
            echo "$output" >&2
            exit 1
          fi
        else
          if [[ "${toString expectFailure}" == "1" ]]; then
            echo "Test '${name}' failed as expected"
            touch $out
            exit 0
          fi
          echo -n ${lib.escapeShellArg command} >&2
          echo " returned a non-zero exit code." >&2
          echo "$output" >&2
          exit 1
        fi
      '';
in
(lib.mapAttrs testDenoRun {
  basic = {
    dir = ./.;
    file = "basic.ts";
    expected = "2";
  };
  import-json = {
    expected = "hello from JSON";
  };
  import-ts = {
    expected = "hello from ts";
  };
  read-file = {
    args = "--allow-read";
    expected = "hello from a file";
  };
  fail-read-file = {
    expectFailure = true;
    dir = ./read-file;
  };
})
// {
  version = testers.testVersion {
    package = deno;
    command = "deno --version";
  };
}

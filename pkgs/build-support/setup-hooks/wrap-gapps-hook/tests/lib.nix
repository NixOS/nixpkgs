{ lib, runCommand }:

rec {
  runTest =
    name: body:
    runCommand name { strictDeps = true; } ''
      set -o errexit
      ${body}
      touch $out
    '';

  skip =
    cond: text:
    if cond then
      ''
        echo "Skipping test $name" > /dev/stderr
      ''
    else
      text;

  fail = text: ''
    echo "FAIL: $name: ${text}" > /dev/stderr
    exit 1
  '';

  expectSomeLineContainingYInFileXToMentionZ = file: filter: expected: ''
    file=${lib.escapeShellArg file} filter=${lib.escapeShellArg filter} expected=${lib.escapeShellArg expected}

    if ! grep --text --quiet "$filter" "$file"; then
        ${fail "The file “$file” should include a line containing “$filter”."}
    fi

    if ! grep --text "$filter" "$file" | grep --text --quiet "$expected"; then
        ${fail "The file “$file” should include a line containing “$filter” that also contains “$expected”."}
    fi
  '';
}

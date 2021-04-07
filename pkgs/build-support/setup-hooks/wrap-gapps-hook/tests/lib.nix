{ runCommand
}:

rec {
  runTest = name: body: runCommand name { } ''
    set -o errexit
    ${body}
    touch $out
  '';

  skip = cond: text:
    if cond then ''
      echo "Skipping test $name" > /dev/stderr
    '' else text;

  fail = text: ''
    echo "FAIL: $name: ${text}" > /dev/stderr
    exit 1
  '';

  expectSomeLineContainingYInFileXToMentionZ = file: filter: expected: ''
    if ! cat "${file}" | grep "${filter}"; then
        ${fail "The file “${file}” should include a line containing “${filter}”."}
    fi

    if ! cat "${file}" | grep "${filter}" | grep ${expected}; then
        ${fail "The file “${file}” should include a line containing “${filter}” that also contains “${expected}”."}
    fi
  '';
}

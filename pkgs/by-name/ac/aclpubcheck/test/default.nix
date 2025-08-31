{
  runCommand,
  aclpubcheck,
}:
runCommand "aclpubcheck-test-example-pdf" { nativeBuildInputs = [ aclpubcheck ]; } ''
  # aclpubcheck prints out the path that was passed to it, which may change over time if it is a Nix store path.
  # Since we're comparing the output of aclpubcheck, this would break the test.
  # To avoid this, pass aclpubcheck a relative path to a symlink in the current working directory instead of the absolute path.
  # Simply using `cd` to change directories into the example directory does not work,
  # since aclpubcheck wants to write some files to the current working directory.
  ln -s '${aclpubcheck.src}/example/2023.acl-tutorials.1.pdf' 2023.acl-tutorials.1.pdf

  aclpubcheck --paper_type long 2023.acl-tutorials.1.pdf > actual-output.txt

  exit_code="$?"
  if [ "$exit_code" != 0 ]; then
    echo "Exit code of aclpubcheck was $exit_code while 0 was expected."
    exit 1
  fi

  if ! diff '${./expected-output.txt}' actual-output.txt; then
    echo
    echo "ERROR: The output was different than expected!"
    echo "The diff is above."
    exit 1
  fi

  touch "$out"
''

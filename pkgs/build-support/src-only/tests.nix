{
  runCommand,
  srcOnly,
  emptyDirectory,
  glibc,
}:

let
  emptySrc = srcOnly emptyDirectory;
  glibcSrc = srcOnly glibc;
in

runCommand "srcOnly-tests" { } ''
  # Test that emptySrc is empty
  if [ -n "$(ls -A ${emptySrc})" ]; then
    echo "emptySrc is not empty"
    exit 1
  fi

  # Test that glibcSrc is not empty
  if [ -z "$(ls -A ${glibcSrc})" ]; then
    echo "glibcSrc is empty"
    exit 1
  fi

  # Make $out exist to avoid build failure
  mkdir -p $out
''

{ runCommand
, diffutils
, ronn
}:
runCommand "ronn-test-reproducible-html" { } ''
  set -euo pipefail

  cat > aprog.1.ronn << EOF
  aprog
  =====

  ## AUTHORS

  Vincent Haupert <veehaitch@users.noreply.github.com>
  EOF

  # We have to repeat the manpage generation a few times to be confident
  # it is in fact reproducible.
  for i in {1..20}; do
    ${ronn}/bin/ronn --html --pipe aprog.1.ronn > aprog.1.html-1
    ${ronn}/bin/ronn --html --pipe aprog.1.ronn > aprog.1.html-2

    ${diffutils}/bin/diff -q aprog.1.html-1 aprog.1.html-2 \
      || (printf 'The HTML manpage is not reproducible (round %d)' "$i" && exit 1)
  done

  echo 'The HTML manpage appears reproducible'

  mkdir $out
''

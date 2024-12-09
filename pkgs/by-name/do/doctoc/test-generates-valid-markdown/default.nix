{ runCommandNoCC, doctoc }:
runCommandNoCC "doctoc-test-generates-valid-markdown.md" { nativeBuildInputs = [ doctoc ]; } ''
  cp ${./input.md} ./target.md && chmod +w ./target.md
  doctoc ./target.md

  # Ensure that ./target.md changed
  cmp --quiet ${./input.md} ./target.md && echo "doctoc-test-generates-valid-markdown: files unchanged, test fails" && exit 1
  # Check for DocToc's default title
  grep --fixed-strings '**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*' target.md
  # Check for at least one Markdown anchor link
  grep --extended-regexp '\- \[.*\]\(#[a-z-]*\)' target.md

  cp target.md $out
''

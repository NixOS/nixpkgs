# Tests the linter by giving a known bad example and expects the linter to report it else
# something's gone awry
{
  runCommand,
  isabelle,
  writableTmpDirAsHomeHook,
}:
let
  isabelle' = isabelle.withComponents (c: [ c.isabelle-linter ]);
in
runCommand "isabelle-linter-test-${isabelle.version}"
  {
    nativeBuildInputs = [
      isabelle'
      writableTmpDirAsHomeHook
    ];
  }
  ''
    mkdir -p "$HOME/.isabelle/etc"
    echo 'ISABELLE_TMP_PREFIX="$TMPDIR/isabelle"' > "$HOME/.isabelle/etc/settings"

    # Isabelle runs poly in a new session, and it seems it can sometimes get orphaned and never cleaned
    # up (at least on Darwin)
    mkdir thy
    cd thy
    cat > ROOT <<'EOF'
    session Lint_Test = HOL +
      theories Test
    EOF
    cat > Test.thy <<'EOF'
    theory Test imports Main begin

    lemma [simp]: "True" by simp

    end
    EOF

    lint_status=0
    isabelle lint -f warn -d . Lint_Test > lint.log 2>&1 || lint_status=$?
    cat lint.log

    if [ "$lint_status" -eq 124 ] || [ "$lint_status" -eq 137 ]; then
      echo "isabelle lint timed out" >&2
    fi

    if ! grep -q global_attribute_on_unnamed_lemma lint.log; then
      echo "isabelle lint failed to report expected lint" >&2
      exit 1
    fi

    if [ "$lint_status" -eq 0 ]; then
      echo "isabelle lint -f warn reported something but exited with 0" >&2
      exit 1
    fi

    cp lint.log $out
  ''

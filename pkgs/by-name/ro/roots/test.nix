{ runCommand, roots }:

runCommand "roots-monorepo-detection"
  {
    nativeBuildInputs = [ roots ];
  }
  ''
    mkdir -p repo/packages/foo repo/packages/bar
    touch repo/go.mod repo/packages/foo/package.json repo/packages/bar/Cargo.toml
    cd repo
    output=$(roots)
    echo "$output"
    grep -qE '/repo$' <<< "$output"
    grep -qE '/repo/packages/foo$' <<< "$output"
    grep -qE '/repo/packages/bar$' <<< "$output"
    touch $out
  ''

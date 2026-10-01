{ runCommand, kubo }:

runCommand "kubo-test-repoVersion" { } ''
  export IPFS_PATH="$TMPDIR"
  "${kubo}/bin/ipfs" init --empty-repo
  declared_repo_version='${kubo.repoVersion}'
  actual_repo_version="$(cat "$IPFS_PATH/version")"
  if [ "$declared_repo_version" != "$actual_repo_version" ]; then
    echo "kubo.repoVersion is not set correctly. It should be $actual_repo_version but is $declared_repo_version."
    exit 1
  fi
  touch "$out"
''

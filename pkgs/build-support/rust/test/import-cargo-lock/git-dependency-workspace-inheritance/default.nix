{ replaceWorkspaceValues, runCommand }:

runCommand "git-dependency-workspace-inheritance-test" { } ''
  cp --no-preserve=mode ${./crate.toml} "$out"
  ${replaceWorkspaceValues} "$out" ${./workspace.toml}
  diff -u "$out" ${./want.toml}
''

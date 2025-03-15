{ replaceWorkspaceValues, runCommand }:

runCommand "workspace-lints-300532" { } ''
  cp --no-preserve=mode ${./crate.toml} "$out"
  ${replaceWorkspaceValues} "$out" ${./workspace.toml}
  diff -u "$out" ${./want.toml}
''

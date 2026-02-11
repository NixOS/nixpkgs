{ replaceWorkspaceValues, runCommand }:

runCommand "git-dependency-workspace-inheritance-test" { } ''
  cp --no-preserve=mode ${./crate.toml} "$out"
  ${replaceWorkspaceValues} "$out" ${./workspace.toml}
  diff -u "$out" ${./want.toml}

  cp --no-preserve=mode ${./crate_lints.toml} "$out"
  ${replaceWorkspaceValues} "$out" ${./workspace.toml}
  diff -u "$out" ${./want_lints.toml}

  cp --no-preserve=mode ${./crate_missing_field.toml} "$out"
  ${replaceWorkspaceValues} "$out" ${./workspace.toml}
  diff -u "$out" ${./want_missing_field.toml}
''

{
  gitMinimal,
  pre-commit,
  runCommand,
  testers,
}:
{
  check-meta-hooks =
    runCommand "check-meta-hooks"
      {
        nativeBuildInputs = [
          gitMinimal
          pre-commit
        ];
      }
      ''
        cd "$(mktemp --directory)"
        export HOME="$PWD"
        cat << 'EOF' > .pre-commit-config.yaml
        repos:
          - repo: local
            hooks:
              - id: echo
                name: echo
                entry: echo
                files: \.yaml$
                language: system
          - repo: meta
            hooks:
              - id: check-hooks-apply
              - id: check-useless-excludes
              - id: identity
        EOF
        git config --global user.email "you@example.com"
        git config --global user.name "Your Name"
        git init --initial-branch=main
        git add .
        pre-commit run --all-files
        touch $out
      '';

  version = testers.testVersion {
    package = pre-commit;
  };
}

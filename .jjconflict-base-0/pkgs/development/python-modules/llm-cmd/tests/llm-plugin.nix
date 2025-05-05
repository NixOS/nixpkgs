{
  runCommand,
  python,
  yq,
}:
let
  venv = python.withPackages (ps: [
    ps.llm
    ps.llm-cmd
  ]);
in
runCommand "llm-cmd-test-llm-plugin"
  {
    nativeBuildInputs = [
      venv
      yq
    ];
  }
  ''
    llm plugins | yq --exit-status 'any(.name == "llm-cmd")'
    touch "$out"
  ''

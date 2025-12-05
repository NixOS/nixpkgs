{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  runCommand,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jaq";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZVTDbJ5RPgQeB4ntnNQcbbWquPFL7q4WYyQ5ihCVB64=";
  };

  cargoHash = "sha256-hEILrjIJK/8CrQv5QcHu+AtPV7KcPdmw6422MyNoPwo=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.simple =
      runCommand "jaq-test"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          set -o pipefail

          # checking if 1 + 2 == 3.
          if [[ "$(echo '{"a": 1, "b": 2}' | jaq 'add')" -eq 3 ]]; then
            echo "test 1 passed"
          else
            echo "test 1 failed"
            exit 1
          fi

          # echo out 0-3, map over them multiplying by 2, keep all elements under 5, add the results up together. Should be 6
          if [[ "$(echo '[0, 1, 2, 3]' | jaq 'map(.*2) | [.[] | select(. < 5)] | add')" -eq 6 ]]; then
            echo "test 2 passed"
          else
            echo "test 2 failed"
            exit 1
          fi

          # fail on malformed input
          if ! echo "0, 1, 4, " | jaq &>/dev/null; then
            echo "test 3 passed"
          else
            echo "test 3 failed"
            exit 1
          fi

          echo "All tests passed!"
          touch $out
        '';
  };

  meta = {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.ngi ];
    maintainers = with lib.maintainers; [
      siraben
    ];
    mainProgram = "jaq";
  };
})

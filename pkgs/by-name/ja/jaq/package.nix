{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  runCommand,
  jotdown,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jaq";
  version = "3.1.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/yAwLcPwfW5UH+PCCrsFaM0Nuk1S5QONLsNgvVCBLX8=";
  };

  cargoHash = "sha256-5+IBUOTO7XNWogQBNEt8XydLZ1xTvldvx5lIfh7K0QA=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  nativeBuildInputs = [
    jotdown # for manpage
  ];

  postBuild = ''
    pushd docs || true
    make jaq.1
    popd
  '';

  postInstall = ''
    install -D docs/jaq.1 -t $out/share/man/man1
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$" ];
    };
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
    changelog = "https://github.com/01mf02/jaq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.ngi ];
    maintainers = with lib.maintainers; [
      siraben
    ];
    mainProgram = "jaq";
  };
})

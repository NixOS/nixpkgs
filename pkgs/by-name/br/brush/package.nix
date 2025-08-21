{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  testers,
  runCommand,
  writeText,
  nix-update-script,
  brush,
}:

rustPlatform.buildRustPackage rec {
  pname = "brush";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "reubeno";
    repo = "brush";
    tag = "brush-shell-v${version}";
    hash = "sha256-CAQkbesP0wqyt7yA53BQlW/tkCoCPKEBoDLTVJBnR6o=";
  };

  cargoHash = "sha256-x/OyO96XKABf1hqSg0GMzWw6aeLOu7z2yu9rQQSM4Lc=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  # Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  passthru = {
    shellPath = "/bin/brush";

    tests = {
      complete = testers.testEqualContents {
        assertion = "brushinfo performs to inspect completions";
        expected = writeText "expected" ''
          brush
          brushctl
          brushinfo
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [ brush ];
            }
            ''
              brush -c 'brushinfo complete line bru' >$out
            '';
      };
    };

    updateScript = nix-update-script { extraArgs = [ "--version-regex=brush-shell-v([\\d\\.]+)" ]; };
  };

  meta = {
    description = "Bash/POSIX-compatible shell implemented in Rust";
    homepage = "https://github.com/reubeno/brush";
    changelog = "https://github.com/reubeno/brush/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kachick ];
    mainProgram = "brush";
  };
}

{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  git,
}:
let
  version = "1.1.8";
in
rustPlatform.buildRustPackage {
  pname = "committed";
  inherit version;

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    tag = "v${version}";
    hash = "sha256-JjVF2Qv3gcS1bNAlWLDHthOgtX3J36IDEb45hMFlPYw=";
  };

  cargoHash = "sha256-W6znChJaDPKdqACDGrVRyEYWKGRinZKLb/21fze2t0c=";

  nativeCheckInputs = [
    git
  ];

  # Ensure libgit2 can read user.name and user.email for `git_signature_default`.
  # https://github.com/crate-ci/committed/blob/v1.1.5/crates/committed/tests/cmd.rs#L126
  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name nobody
    git config --global user.email no@where
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/crate-ci/committed";
    changelog = "https://github.com/crate-ci/committed/blob/v${version}/CHANGELOG.md";
    description = "Nitpicking commit history since beabf39";
    mainProgram = "committed";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.pigeonf ];
  };
}

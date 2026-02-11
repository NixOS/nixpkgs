{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  git,
}:
let
  version = "1.1.10";
in
rustPlatform.buildRustPackage {
  pname = "committed";
  inherit version;

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    tag = "v${version}";
    hash = "sha256-shYfKpQl0hv9m/x9UuWFksdNB6mkeQPFPP16vGxUbVw=";
  };

  cargoHash = "sha256-CK/vYcxYXE/hEq1h9mgwrYyeS36hfiYC8WDJN9iNH6s=";

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

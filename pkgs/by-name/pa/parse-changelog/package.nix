{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "parse-changelog";
  version = "0.6.17";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "taiki-e";
    repo = "parse-changelog";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QCv4vvpqxUrzykYPJXwQULTh7/JTSm1HLnLE1gWX6Js=";
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;

    outputHashes = {
      "criterion-0.3.5" = "sha256-vasRbZPzun4W+T9MxJDFOYGpGAHgrFS7hQh86bAmet8=";
      "test-helper-0.0.0" = "sha256-nPNYhfGVL6rNdfCoWLNJuVeP6Gt4m1CwEOyPtFYIXfk=";
    };
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--generate-lockfile" ];
  };

  meta = {
    homepage = "https://github.com/taiki-e/parse-changelog";
    changelog = "https://github.com/taiki-e/parse-changelog/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Simple changelog parser, written in Rust";
    mainProgram = "parse-changelog";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      pigeonf
    ];
  };
})

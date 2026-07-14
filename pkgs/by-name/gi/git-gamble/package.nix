{
  lib,
  rustPlatform,
  fetchFromGitLab,
  gitMinimal,
  installShellFiles,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-gamble";
  version = "2.14.4";

  src = fetchFromGitLab {
    owner = "pinage404";
    repo = "git-gamble";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DjwdoM9/W1UeD/XqVMXTyzjdcJLfHiAqRA3r//rkn1U=";
  };

  cargoHash = "sha256-X3kJT0pscCH9sQxV3NkX0hL2sccTJHgMj0UeIpJOWJ4=";

  nativeCheckInputs = [ gitMinimal ];
  preCheck = ''
    patchShebangs tests/editor/fake_editor.sh
  '';
  checkFlags = [
    # this test can be flaky ; help is needed to stabilize it in upstream
    "--skip=git_gamble::cancel_command_with_signal::fail_when_git_is_killed"
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];
  postInstall = ''
    wrapProgram $out/bin/git-gamble \
      --prefix PATH : "${lib.makeBinPath [ gitMinimal ]}"

    wrapProgram $out/bin/git-time-keeper \
      --prefix PATH : "${lib.makeBinPath [ gitMinimal ]}"

    export PATH="$PATH:$out/bin/"

    sh ./script/generate_completion.sh target/release/shell_completions/
    installShellCompletion --cmd git-gamble \
      --bash target/release/shell_completions/git-gamble.bash \
      --fish target/release/shell_completions/git-gamble.fish \
      --zsh target/release/shell_completions/_git-gamble

    sh ./script/usage.sh > git-gamble.1
    installManPage git-gamble.1
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(.*)"
    ];
  };

  meta = {
    description = "Tool that blends TDD (Test Driven Development) + TCR (`test && commit || revert`)";
    homepage = "https://git-gamble.is-cool.dev";
    changelog = "https://git-gamble.is-cool.dev/changelog/${finalAttrs.version}.html";
    license = lib.licenses.isc;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.pinage404 ];
    mainProgram = "git-gamble";
  };
})

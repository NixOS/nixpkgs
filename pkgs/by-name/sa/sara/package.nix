{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sara";
  version = "0.12.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cledouarec";
    repo = "sara";
    tag = "sara-cli-v${finalAttrs.version}";
    hash = "sha256-/Y19bcMeRy0cFoKI5p7ByqDcVL2wWQJFGn+vuyzu/UA=";
  };

  cargoHash = "sha256-1R0fIzj0O8RBzEMicyqKrnk9MhG/LEUSJPzDKglQqXM=";

  # The CLI integration tests shell out to `git` to build fixture repositories.
  nativeCheckInputs = [ git ];

  checkFlags = [
    # Asserts that the working directory is a git repository, which only holds
    # when running from an upstream checkout rather than an unpacked tarball.
    "--skip=repository::git::tests::test_is_git_repo"
  ];

  # buildRustPackage sets RUST_LOG to an empty string, which
  # EnvFilter::try_from_default_env() accepts as an empty filter and silences
  # the warnings the stderr logging tests assert on.
  preCheck = ''
    unset RUST_LOG
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # sara-cli, sara-core and sara-mcp are tagged separately in this
      # repository, only follow the CLI which provides the `sara` binary.
      "--version-regex"
      "sara-cli-v([0-9.]+)"
    ];
  };

  meta = {
    description = "Manage architecture documents and requirements as a knowledge graph";
    homepage = "https://embedded-leadership.com/projects/sara/";
    changelog = "https://github.com/cledouarec/sara/blob/sara-cli-v${finalAttrs.version}/sara-cli/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yasunori0418 ];
    mainProgram = "sara";
    platforms = lib.platforms.unix;
  };
})

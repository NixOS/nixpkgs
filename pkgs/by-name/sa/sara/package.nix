{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sara";
  version = "0.9.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cledouarec";
    repo = "sara";
    tag = "sara-cli-v${finalAttrs.version}";
    hash = "sha256-aBy2Gh2+XKpXdiVHcUcDpjypxkCKDdYgW16diY2cvmE=";
  };

  cargoHash = "sha256-RWAR+v8SsB154DzWTKFIFDJmBvknRH4ro1QosvlnhcY=";

  # The CLI integration tests shell out to `git` to build fixture repositories.
  nativeCheckInputs = [ git ];

  checkFlags = [
    # Asserts that the working directory is a git repository, which only holds
    # when running from an upstream checkout rather than an unpacked tarball.
    "--skip=repository::git::tests::test_is_git_repo"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # Both sara-cli and sara-core are tagged in this repository, only follow
      # the CLI which provides the `sara` binary.
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

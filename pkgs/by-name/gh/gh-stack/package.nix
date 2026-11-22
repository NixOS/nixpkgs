{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
  gitMinimal,
  installAgentSkills,
}:

buildGoModule (finalAttrs: {
  pname = "gh-stack";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-stack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dENuxVuz68Y7P8WW5C7pzVbfJRxGMGIKQ2AnWrTacOs=";
  };

  vendorHash = "sha256-y+eTfmZTdSkHh943o/XtFrrMWv/lxvWekKUp/JKb0h4=";

  ldflags = [
    "-s"
    "-X=github.com/github/gh-stack/cmd.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installAgentSkills
  ];

  nativeCheckInputs = [ gitMinimal ];

  # some tests resolve branches through git and need to run inside a repository
  preCheck = ''
    git init --quiet
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # By default, a "test" binary is installed in the bin directory.  That
  # doesn't seem to be useful for end users, and can conflict with the "test"
  # binary that some applications expect to find on the PATH as provided by
  # coreutils or similar.
  fixupPhase = ''
    rm "$out"/bin/test
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitHub CLI extension to use stacked PRs";
    homepage = "https://github.github.com/gh-stack/";
    downloadPage = "https://github.com/github/gh-stack/";
    changelog = "https://github.com/github/gh-stack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      antoineco
      ethancedwards8
      mdaniels5757
    ];
    mainProgram = "gh-stack";
  };
})

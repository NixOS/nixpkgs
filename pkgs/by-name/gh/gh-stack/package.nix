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

  # Only install the gh-stack executable, not the test executable.
  subPackages = [ "." ];

  nativeCheckInputs = [ gitMinimal ];

  preCheck =
    # Some tests resolve branches through git and need to run inside a
    # repository.
    ''
      git init --quiet
    ''
    # Having subPackages set prevents some of the tests from being run, so unset
    # it while running the check phase.
    + ''
      orig_subPackages="$(declare -p subPackages)"
      unset subPackages
    '';

  # Restore the value of subPackages in case it's needed by any later phases.
  postCheck = ''
    eval "$orig_subpackages"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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

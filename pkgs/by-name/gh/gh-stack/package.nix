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
  version = "0.2.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-stack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mq4jAqeSHDuCiDYSa40okrq06UhC3dZGjgCXJKMbgzU=";
  };

  vendorHash = "sha256-TC1mSXYjOQo00fb2yuGdk1rl6z6rp0WT3AmzXomPzis=";

  # the go-modules derivation inherits the installAgentSkills hook but has no pname
  overrideModAttrs = _: {
    dontInstallAgentSkills = true;
  };

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
    ];
    mainProgram = "gh-stack";
  };
})

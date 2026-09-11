{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "gh-stack";
  version = "0.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-stack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jwfqiCnCOOW0AKA52hbgvCCoLzfFX+QfM+vXABkzZgw=";
  };

  vendorHash = "sha256-0Xtr/MOpX4u5GnbRdNxKPA0GpSzi8PIbVc9MmP05De4=";

  nativeCheckInputs = [ gitMinimal ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/github/gh-stack/cmd.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    install -Dm444 skills/gh-stack/SKILL.md $out/share/skills/gh-stack/gh-stack/SKILL.md
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

{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGo127Module (finalAttrs: {
  __structuredAttrs = true;

  pname = "gitsnip";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dagimg-dot";
    repo = "gitsnip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SJQo8IXKjM28q7HqpB29UExeDB1BpeaVpA+Bv8XN4bI=";
  };

  vendorHash = "sha256-9eQJkUmVhIjlTSG0YXQ+SLeGAYtPgQsVbjxiwYCYogE=";

  ldflags = [
    "-s -w"
    "-X github.com/dagimg-dot/gitsnip/internal/cli.version=${finalAttrs.version}"
    "-X github.com/dagimg-dot/gitsnip/internal/cli.commit=refs/tags/v${finalAttrs.version}"
    "-X github.com/dagimg-dot/gitsnip/internal/cli.builtBy=nixpkgs"
  ];

  # TestVersion expects the "upstream dev" build string. The version is already checked by the versionCheckHook.
  checkFlags = [ "-skip=^TestVersion$" ];

  # httptest.NewServer binds loopback, but the Darwin sandbox denies access by default.
  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to download specific folders from a git repository";
    homepage = "https://github.com/dagimg-dot/gitsnip/";
    changelog = "https://github.com/dagimg-dot/gitsnip/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "gitsnip";
  };
})

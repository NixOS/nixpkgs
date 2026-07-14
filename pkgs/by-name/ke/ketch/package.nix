{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ketch";
  version = "0.10.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "1broseidon";
    repo = "ketch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m6KEPbNd13eJsNigJyGGlV2dt0bcZTZcDBCBh/l5rjY=";
  };

  vendorHash = "sha256-UsTR7+GSuxUQ0aBq8fv1M18LegeDqf/XoiyASQKe5EI=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/1broseidon/ketch/cmd.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, stateless CLI for web search and scrape. Built for AI agents.";
    homepage = "https://chain.sh/ketch/";
    changelog = "https://github.com/1broseidon/ketch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stephsi
    ];
    mainProgram = "ketch";
  };
})

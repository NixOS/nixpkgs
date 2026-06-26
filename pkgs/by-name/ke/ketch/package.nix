{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "ketch";
  version = "0.9.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "1broseidon";
    repo = "ketch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bcmSPslW/k5OO+Zce6N0S3NoQeXGOM6DcZ4Cj2W2C14=";
  };

  vendorHash = "sha256-m3IwAYsczsxcVk9fay+f2AsNjmXoPk7NS0abES6b594=";

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

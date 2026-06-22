{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "monocle-review";
  version = "0.46.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "josephschmitt";
    repo = "monocle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2ye2Y/yrJXebGX++B8ILDhZpsm4NxZ5RRRDI/dzfOpY=";
  };

  vendorHash = "sha256-oajKuhbP+DRXefoJbrOVoyE1rOdtZaPS4c3u0HUP4Kc=";

  subPackages = [ "cmd/monocle" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real-time TUI code review for AI coding agents";
    homepage = "https://github.com/josephschmitt/monocle";
    changelog = "https://github.com/josephschmitt/monocle/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ josephschmitt ];
    mainProgram = "monocle";
  };
})

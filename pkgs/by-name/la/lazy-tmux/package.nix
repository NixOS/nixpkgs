{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "lazy-tmux";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "alchemmist";
    repo = "lazy-tmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r4XIuYHD7MHkgViaDH6KIJF1rpu5Hj+HrqVF45M1Ojc=";
  };

  vendorHash = "sha256-wOEt++ZPUJ4fER7o/UiX9kzHaA0iTM3smgqJQdu9aSk=";

  subPackages = [ "cmd/lazy-tmux" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast session manager and saver for tmux";
    homepage = "https://github.com/alchemmist/lazy-tmux";
    changelog = "https://github.com/alchemmist/lazy-tmux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chansuke ];
    mainProgram = "lazy-tmux";
  };
})

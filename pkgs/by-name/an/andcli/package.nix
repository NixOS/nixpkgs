{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "andcli";
  version = "2.7.0";

  subPackages = [ "cmd/andcli" ];

  src = fetchFromGitHub {
    owner = "tjblackheart";
    repo = "andcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l+ZpAm+yHCKPalGib4OlIaGFsDHc3IFFlOvB1kXWZG0=";
  };

  vendorHash = "sha256-S2JRkVy1iLGBqoOWukTQm80fVJ2YMNHTLfUUA2530GE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tjblackheart/andcli/v2/internal/buildinfo.Commit=${finalAttrs.src.tag}"
    "-X github.com/tjblackheart/andcli/v2/internal/buildinfo.AppVersion=${finalAttrs.src.tag}"
  ];

  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tjblackheart/andcli";
    description = "2FA TUI for your shell";
    changelog = "https://github.com/tjblackheart/andcli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "andcli";
  };
})

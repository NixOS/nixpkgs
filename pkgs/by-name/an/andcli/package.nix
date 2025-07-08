{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "andcli";
  version = "2.2.0";

  subPackages = [ "cmd/andcli" ];

  src = fetchFromGitHub {
    owner = "tjblackheart";
    repo = "andcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wAatlCckSpa/BE4UVR/L6SkVmNyW2/cl//JOy62EaLc=";
  };

  vendorHash = "sha256-/rmx9g7OfsZXr3zb1UfR1qLxdV2/ELzc/wXn0fJRzbE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tjblackheart/andcli/v2/internal/buildinfo.Commit=${finalAttrs.src.tag}"
    "-X github.com/tjblackheart/andcli/v2/internal/buildinfo.AppVersion=${finalAttrs.src.tag}"
  ];

  # As stated in #404465 the versionCheckHook does not work so it is not used here

  meta = {
    homepage = "https://github.com/tjblackheart/andcli";
    description = "2FA TUI for your shell";
    changelog = "https://github.com/tjblackheart/andcli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "andcli";
  };
})

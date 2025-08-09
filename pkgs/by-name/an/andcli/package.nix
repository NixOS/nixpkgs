{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "andcli";
  version = "2.3.0";

  subPackages = [ "cmd/andcli" ];

  src = fetchFromGitHub {
    owner = "tjblackheart";
    repo = "andcli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-umV0oJ4sySnZzrIpRuTP/fT8a9nhkC1shVEfVVRpEyI=";
  };

  vendorHash = "sha256-lzmkNxQUqktnl2Rpjgoa2yvAuGiMtVGNhiuF40how4o=";

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

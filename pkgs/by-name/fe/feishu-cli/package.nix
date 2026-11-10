{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "feishu-cli";
  version = "1.43.0";

  src = fetchFromGitHub {
    owner = "riba2534";
    repo = "feishu-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GvmZAQf2yAfFmJmCr+nJQpdvegvnSknjTtFt31HecLM=";
  };

  vendorHash = "sha256-RdgOYh4DeGW2YOj4HBQUCCh8u1ekNPYEvn7KRGSXW78=";

  subPackages = [ "." ];

  ldflags = [ "-X main.Version=${finalAttrs.src.tag}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Feishu (Lark) Open Platform";
    homepage = "https://github.com/riba2534/feishu-cli";
    changelog = "https://github.com/riba2534/feishu-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "feishu-cli";
  };
})

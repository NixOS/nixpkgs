{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "feishu-cli";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "riba2534";
    repo = "feishu-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8GIEa2P3s3sF0o4SyAjLxgHNFi5+4F19T+EsJ1d1Oik=";
  };

  vendorHash = "sha256-MZv772U+3+Fcanaiuhz+OCqfIsYyCG7B4iZOnEftbi8=";

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

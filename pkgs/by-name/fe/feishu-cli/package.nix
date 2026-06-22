{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "feishu-cli";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "riba2534";
    repo = "feishu-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kPA+t5PiIfIuskgL608J0JzmBELytO7GP13gSnkxoo8=";
  };

  vendorHash = "sha256-vRefU38o9Q4Q96aXoUXUggcRsfQePjlUrSsNERJH3YU=";

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

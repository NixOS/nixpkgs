{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "feishu-cli";
  version = "1.38.3";

  src = fetchFromGitHub {
    owner = "riba2534";
    repo = "feishu-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wLPR7uet73JUOgXqneNAPy3Rk3/WMSnIa6zIQUXEcic=";
  };

  vendorHash = "sha256-JhrcuZ/FyvtUfsSq6YoYHNMjqFU/+FhxgCJ5bPtyYD8=";

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

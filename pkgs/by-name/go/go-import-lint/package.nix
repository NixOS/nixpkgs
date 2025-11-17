{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "go-import-lint";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "hedhyw";
    repo = "go-import-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YaIKtbdjqtmHGZgk3AlHrSJrWGMGJTIv1t/LYoB4vmw=";
  };
  vendorHash = null;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Golang source code analyzer that checks imports order";
    homepage = "https://github.com/hedhyw/go-import-lint";
    changelog = "https://github.com/hedhyw/go-import-lint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    mainProgram = "go-import-lint";
  };
})

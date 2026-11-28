{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "oxidized-exporter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "akquinet";
    repo = "oxidized-exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZtmPr9WrOWBtcO+D4zC28J7zeLByYMsIL+4MnqRHFXU=";
  };

  vendorHash = "sha256-cjWVpyrHbCgMc0k8sDy1+Scy12ZZnI4v0kRqTbl+xXo=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) oxidized;
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "Oxidized prometheus exporter to expose device backup metrics";
    homepage = "https://github.com/akquinet/oxidized-exporter";
    changelog = "https://github.com/akquinet/oxidized-exporter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "oxidized-exporter";
  };
})

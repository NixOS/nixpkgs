{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  tantivy-go,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "anytype-cli";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+GVV5HiOB/589IKRs+uJaK8X29MCg5cv0C8u6spb7Jg=";
  };

  vendorHash = "sha256-uxKDO55CQYn50XpnlP5tv5Rcl6+fq7nsOD7/2foRZX8=";
  proxyVendor = true;

  env.CGO_ENABLED = 1;
  env.CGO_LDFLAGS = "-L${tantivy-go}/lib";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anyproto/anytype-cli/core.Version=v${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for interacting with Anytype";
    homepage = "https://github.com/anyproto/anytype-cli";
    changelog = "https://github.com/anyproto/anytype-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "anytype-cli";
    maintainers = with lib.maintainers; [
      adda
      wanderer
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

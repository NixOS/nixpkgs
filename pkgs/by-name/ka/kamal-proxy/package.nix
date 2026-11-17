{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kamal-proxy";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "kamal-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kB2mOw3/kkckiud00HeOQ4ItyKfAfeeK6xR1vuJZgjo=";
  };

  vendorHash = "sha256-Zw2a3mBmYNvIYXg7TdO6zi9PHPyGDdbKj6eOVvBWVQY=";

  subPackages = [ "cmd/kamal-proxy" ];

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight proxy server for Kamal";
    homepage = "https://github.com/basecamp/kamal-proxy";
    changelog = "https://github.com/basecamp/kamal-proxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "kamal-proxy";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jasanfarah ];
  };
})

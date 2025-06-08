{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kamal-proxy";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "kamal-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oY1XwhoZx/GMg46nQAOK6tx9VzQoXTNdxE26FjBvbsg=";
  };

  vendorHash = "sha256-EDPHqVGkZeaV/9p3EywUkQTNbIdBkAjre9oxRi4c+WY=";

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

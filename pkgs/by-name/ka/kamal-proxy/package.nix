{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "kamal-proxy";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "kamal-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cx4ruglwWWhzbb+rdEz3iUXK1F3mhregz/QY/4YjjT0=";
  };

  vendorHash = "sha256-LQjpn5fKADbYPIsRshzdMNViw4j43hOdWeerB3GRRkY=";

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

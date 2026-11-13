{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "kamal-proxy";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "basecamp";
    repo = "kamal-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2hVmQnFZ5HftoPU8ELoi76QqnZwP+deIWWImcmcOGh8=";
  };

  vendorHash = "sha256-82a2r5zKZu3Yh+9Vl9NroVxIP2T0KR7Vdn2GjuS3Uy0=";

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

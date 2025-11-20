{
  lib,
  buildGoModule,
  fetchFromGitHub,
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

  ldflags = [
    "-s"
  ];

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/basecamp/kamal-proxy";
    description = "Lightweight proxy server for Kamal";
    license = lib.licenses.mit;
    mainProgram = "kamal-proxy";
    maintainers = with lib.maintainers; [
      jasanfarah
    ];
  };
})

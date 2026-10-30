{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "go-avahi-cname";
  version = "2.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grishy";
    repo = "go-avahi-cname";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X3v+7ymiYENfsFJirVWtA8IETlT56ztPgEm7W2cPzLs=";
  };

  vendorHash = "sha256-4ZHzgYjwg8ye94hoEMmQibEzbGQb/lilq2PbYPCHyhY=";

  ldflags = [
    "-w"
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  # bind: operation not permitted
  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight mDNS publisher of subdomains for your machine";
    homepage = "https://github.com/grishy/go-avahi-cname";
    changelog = "https://github.com/grishy/go-avahi-cname/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
    mainProgram = "go-avahi-cname";
  };
})

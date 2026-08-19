{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "go-avahi-cname";
  version = "2.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "grishy";
    repo = "go-avahi-cname";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MeEytTRZF5zpfWYNzvqiMdjvf6IJpS1t5V7+D08GjAY=";
  };

  vendorHash = "sha256-vbIHB9u9Ftwdw7rHnj6rkk/ABmESNvOgp0hixeWVnkI=";

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

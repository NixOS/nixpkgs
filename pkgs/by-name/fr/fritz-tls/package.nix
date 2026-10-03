{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
}:

buildGo127Module (finalAttrs: {
  pname = "fritz-tls";
  version = "0.29.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tisba";
    repo = "fritz-tls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8N2AtNGnr7QMrtN6fuvhtuUAIERKqZ+ZM701zgtvudg=";
  };

  vendorHash = "sha256-WwX8o4Z4Jz3tixbl2YKQ0GiT4b1dGhV/JzMNDRD4oRM=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  env = {
    CGO_ENABLED = "0";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automate TLS certificate installation for AVM FRITZ!Box";
    homepage = "https://github.com/tisba/fritz-tls";
    changelog = "https://github.com/tisba/fritz-tls/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "fritz-tls";
  };
})

{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gollama";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "sammcj";
    repo = "gollama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LjgQSV7Z2apcdIaxk9NU7AdlPJPlt7CQ/q9nID9Px5w=";
  };

  vendorHash = "sha256-xpAAtJIJtETbDYwieLBI7L79SedeAOmYnHL9zq6l7Rs=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go manage your Ollama models";
    homepage = "https://github.com/sammcj/gollama";
    changelog = "https://github.com/sammcj/gollama/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gollama";
  };
})

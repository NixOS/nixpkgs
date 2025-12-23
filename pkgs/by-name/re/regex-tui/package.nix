{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "regex-tui";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "vitor-mariano";
    repo = "regex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5JwK408inZ2VV6KKYM3bdyxVGfyIQXV8WHMpeHAJWFM=";
  };

  vendorHash = "sha256-roio+b3SLO36owTXkPazYwzWF9aWjiaUhggjm6S70Jw=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visualize regular expressions right in your terminal";
    homepage = "https://github.com/vitor-mariano/regex-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "regex-tui";
  };
})

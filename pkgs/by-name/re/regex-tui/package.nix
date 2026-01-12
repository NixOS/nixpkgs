{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "regex-tui";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "vitor-mariano";
    repo = "regex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-69bchXYcak1uYlAAjO14ejUMkTtkSc+8RhOjvMUJUQg=";
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

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "claudeline";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "fredrikaverpil";
    repo = "claudeline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VogE3MAc/EGdokvm/bThqH/gJ/sJXV9FR8JBWjgF7LE=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic Claude Code status line";
    homepage = "https://github.com/fredrikaverpil/claudeline";
    changelog = "https://github.com/fredrikaverpil/claudeline/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fredrikaverpil ];
    mainProgram = "claudeline";
    platforms = lib.platforms.unix;
  };
})

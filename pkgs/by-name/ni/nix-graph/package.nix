{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nix-graph";
  version = "0.1.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AlexAntonik";
    repo = "nix-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ozENFD/Sus/ntu/cE+SlkvCaQ/sdFhUQfwK2zoldAjU=";
  };

  vendorHash = null;
  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/AlexAntonik/nix-graph";
    description = "Interactive TUI viewer for Nix dependency graphs";
    license = lib.licenses.mit;
    mainProgram = "nix-graph";
    maintainers = with lib.maintainers; [ AlexAntonik ];
    platforms = lib.platforms.unix;
  };
})

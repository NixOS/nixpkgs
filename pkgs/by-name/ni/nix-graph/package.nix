{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nix-graph";
  version = "0.0.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "AlexAntonik";
    repo = "nix-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YyXtVTBExTTOMv1eqYlhzbAhPqkdHKqO3f7y9C/Sq9k=";
  };

  vendorHash = null;
  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
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

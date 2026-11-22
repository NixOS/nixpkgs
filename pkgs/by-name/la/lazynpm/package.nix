{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lazynpm";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "jesseduffield";
    repo = "lazynpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tMUM9GzzTwp/C9hET301LrdWJzVSMYabSQxM78WdE9M=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.buildSource=nixpkgs"
  ];

  meta = {
    description = "Terminal UI for npm";
    homepage = "https://github.com/jesseduffield/lazynpm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "lazynpm";
  };
})

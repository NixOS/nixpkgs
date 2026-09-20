{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kagent";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "kagent-dev";
    repo = "kagent";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T/jmvEqHz1obpQehh0GYBuMdtFuaiaWuO+sMPPAypJE=";
  };

  vendorHash = "sha256-b/aXdojD/kdMAIWRtMsN0YOJuY31qb6W/wHdHOhZ0Oo=";
  sourceRoot = "${finalAttrs.src.name}/go";
  subPackages = [
    "cli/cmd/kagent"
  ];

  env.CGO_ENABLED = 0;
  ldflags = [
    "-s"
    "-w"
    "-X github.com/kagent-dev/kagent/go/cli/internal/cli.Version=${finalAttrs.version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool to interact with Kubernetes AI agents";
    homepage = "https://github.com/kagent-dev/kagent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicolas-goudry ];
    mainProgram = "kagent";
    platforms = lib.platforms.all;
  };
})

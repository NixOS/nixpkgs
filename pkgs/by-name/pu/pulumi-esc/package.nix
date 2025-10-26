{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "pulumi-esc";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "esc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0CjlnSGpSJbiQalc22T+cMWjmFfC4dwo29M5m0wqebQ=";
  };

  subPackages = "cmd/esc";

  vendorHash = "sha256-QDevyfNos1+kZmBJDKQH43EJ66XyrRPjdAkrhRqFJNU=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/pulumi/esc/cmd/esc/cli/version.Version=${finalAttrs.src.rev}"
  ];

  meta = {
    description = "Pulumi ESC (Environments, Secrets, and Configuration) for cloud applications and infrastructure";
    homepage = "https://github.com/pulumi/esc/tree/main";
    changelog = "https://github.com/pulumi/esc/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "esc";
  };
})

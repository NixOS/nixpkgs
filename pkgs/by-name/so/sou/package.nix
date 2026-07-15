{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  sou,
}:

buildGoModule (finalAttrs: {
  pname = "sou";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "knqyf263";
    repo = "sou";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uGYCmW60OvEfserujQMXC9r8S8W+EN+w9EXUGjk1vtw=";
  };

  vendorHash = "sha256-6kgiZx/g1PA7R50z7noG+ql+S9wSgTuVTkY5DIqeJHY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  # Some of the tests use localhost networking
  __darwinAllowLocalNetworking = true;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      command = "HOME=$TMPDIR sou --version";
      package = sou;
    };
  };

  meta = {
    description = "Tool for exploring files in container image layers";
    homepage = "https://github.com/knqyf263/sou";
    changelog = "https://github.com/knqyf263/sou/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nicolas-goudry ];
    mainProgram = "sou";
  };
})

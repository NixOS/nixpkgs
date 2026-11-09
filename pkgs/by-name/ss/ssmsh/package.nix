{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ssmsh,
}:

buildGoModule (finalAttrs: {
  pname = "ssmsh";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = "ssmsh";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mRSBMX0pP7joCjd0AJ5qfxRlmrr6OIv1uoB+C+PMvws=";
  };

  vendorHash = "sha256-0hcx1prj6JVgC/Ji/R1wIbGlgqThTylGHyTxKnJ5uWc=";

  doCheck = true;

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru.tests = testers.testVersion {
    package = ssmsh;
    command = "ssmsh -version";
    version = "Version ${finalAttrs.version}";
  };

  meta = {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "Interactive shell for AWS Parameter Store";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dbirks ];
    mainProgram = "ssmsh";
  };
})

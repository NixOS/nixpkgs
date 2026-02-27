{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fq,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "fq";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${finalAttrs.version}";
    hash = "sha256-b28zncqz0B1YIXHCjklAkVbIdXxC36bqIwJ4VrrCe18=";
  };

  vendorHash = "sha256-bF3N+cPJAxAEFmr2Gl3xdKLtv7yLkxze19NgDFWaBn8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
})

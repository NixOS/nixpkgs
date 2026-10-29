{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "falcoctl";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "falcoctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zY6SU9ker5wt6hvbSPap/0IHm7y1TXDGGgay65hRBIc=";
  };

  vendorHash = "sha256-Q0u3dHpKh+fO3cAin5RCCn3Hj5SrVDio7IbOWBpIqJE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/falcosecurity/falcoctl/cmd/version.semVersion=${finalAttrs.version}"
  ];

  # require network
  doCheck = false;

  meta = {
    description = "Administrative tooling for Falco";
    mainProgram = "falcoctl";
    homepage = "https://github.com/falcosecurity/falcoctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      developer-guy
      kranurag7
      LucaGuerra
    ];
  };
})

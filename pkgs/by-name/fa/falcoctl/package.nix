{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "falcoctl";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "falcoctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3EsJiK9Cou+FD3nDbE+j7qGXg2FWmXbg3Mu+UBfptlo=";
  };

  vendorHash = "sha256-U7gWIYh8QLMo/Y1dWv1InRDcAfLTq+5LuWqAABF0SVA=";

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

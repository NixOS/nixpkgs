{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "falcoctl";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "falcosecurity";
    repo = "falcoctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nqikPwIlDZQLs6JQ8DSKGOHlp0qt3OLe0p5y33qR0cI=";
  };

  vendorHash = "sha256-FYbmrdg8K5ptVdG1qs5dCQ+2faBCHBxe4wCD4tHhgss=";

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

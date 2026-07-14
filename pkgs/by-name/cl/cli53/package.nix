{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  cli53,
}:

buildGoModule (finalAttrs: {
  pname = "cli53";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "barnybug";
    repo = "cli53";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ojLqveOZ8IIJXNd6PdXbqWYcwXqAjjEpKiquqXwcZt8=";
  };

  vendorHash = "sha256-OpBeuIyyFOliVtN1z9Ll9ji2qNS41NvZBjL7vJvRe6E=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/barnybug/cli53.version=${finalAttrs.version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = cli53;
  };

  meta = {
    description = "CLI tool for the Amazon Route 53 DNS service";
    homepage = "https://github.com/barnybug/cli53";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benley ];
    mainProgram = "cli53";
  };
})

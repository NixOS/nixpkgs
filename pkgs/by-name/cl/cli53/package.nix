{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  cli53,
}:

buildGoModule (finalAttrs: {
  pname = "cli53";
  version = "0.8.22";

  src = fetchFromGitHub {
    owner = "barnybug";
    repo = "cli53";
    rev = finalAttrs.version;
    sha256 = "sha256-wfb3lK/WB/B8gd4BOqh+Ol10cNZdsoCoQ+hM33+goM8=";
  };

  vendorHash = "sha256-LKJXoXZS866UfJ+Edwf6AkAZmTV2Q1OI1mZfbsxHb3s=";

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

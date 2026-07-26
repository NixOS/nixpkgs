{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  risor,
}:

buildGoModule (finalAttrs: {
  pname = "risor";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "risor-io";
    repo = "risor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SXUaSJmtWul4LYRdoxv4lXBB4HHp62xrWbEchI691YY=";
  };

  proxyVendor = true;
  vendorHash = "sha256-WUvCzdDSsCan4K568k53oveYIzFQCxFi2B9gQEaeFEM=";

  subPackages = [
    "cmd/risor"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = risor;
      command = "risor version";
    };
  };

  meta = {
    description = "Fast and flexible scripting for Go developers and DevOps";
    mainProgram = "risor";
    homepage = "https://github.com/risor-io/risor";
    changelog = "https://github.com/risor-io/risor/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})

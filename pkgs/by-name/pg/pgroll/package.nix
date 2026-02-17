{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libpg_query,
  xxHash,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "pgroll";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xl6mJkJbZ+N/HjrUsknC1UFOM9GFtY4UYnabXvTwkAc=";
  };

  proxyVendor = true;

  vendorHash = "sha256-j78c7pROEiJVsE0e0hxbr+0uqOmGcBsK1U0F1upgWIw=";

  excludedPackages = [
    "dev"
    "tools"
  ];

  buildInputs = [
    libpg_query
    xxHash
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xataio/pgroll/cmd.Version=${finalAttrs.version}"
  ];

  # Tests require a running docker daemon
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "PostgreSQL zero-downtime migrations made easy";
    license = lib.licenses.asl20;
    mainProgram = "pgroll";
    homepage = "https://github.com/xataio/pgroll";
    maintainers = with lib.maintainers; [ ilyakooo0 ];
  };
})

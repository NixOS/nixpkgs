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
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5mo6USnCzYRNx8i0pjxjfas/iZWFnRh3hY6hf17JAT4=";
  };

  proxyVendor = true;

  vendorHash = "sha256-/oEZbST2Q2HG+qu8nH+mdk/U58aTMznndDHDbFg8fCk=";

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

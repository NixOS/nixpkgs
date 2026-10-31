{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libpg_query,
  xxhash,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "pgroll";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J5Q5GFw/t6/FRraO7v0vF+s58zJABhRHr2wpeNlLH3c=";
  };

  proxyVendor = true;

  vendorHash = "sha256-9s6+EXfo5+Tn3LVo/GMzj7DnczAR2NkiiKze1EcRH1Q=";

  excludedPackages = [
    "dev"
    "tools"
  ];

  buildInputs = [
    libpg_query
    xxhash
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

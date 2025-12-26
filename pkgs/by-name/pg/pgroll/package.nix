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
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OqBgFeXpvoImoPMKHBCvsPQGhHSBZuNNMLh2/3DPPYo=";
  };

  proxyVendor = true;

  vendorHash = "sha256-rQPWL39AD/qCneuRyJHOQCANmDE7pqmwHx+AavJ/3cw=";

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

{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cdk-go";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "cdk-team";
    repo = "CDK";
    tag = "v${version}";
    hash = "sha256-mknmpRp8IcqSz7HrD8ertEfv+j6lNVjvjxTWa/qqWR0=";
  };

  vendorHash = "sha256-aJN/d/BxmleRXKw6++k6e0Vb0Gs5zg1QfakviABYTog=";

  # At least one test is outdated
  doCheck = false;

  meta = {
    description = "Container penetration toolkit";
    homepage = "https://github.com/cdk-team/CDK";
    changelog = "https://github.com/cdk-team/CDK/releases/tag/v${version}";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cdk";
    broken = stdenv.hostPlatform.isDarwin; # needs to update gopsutil to at least v3.21.3 to include https://github.com/shirou/gopsutil/pull/1042
  };
}

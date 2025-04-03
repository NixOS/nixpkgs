{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libpg_query,
  xxHash,
}:

buildGoModule rec {
  pname = "pgroll";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${version}";
    hash = "sha256-AJ0dTvywbwwSHOwSPrAgTE9M1AMvo/GRj6L1dZM9Hz8=";
  };

  proxyVendor = true;

  vendorHash = "sha256-olblf/mi/M9Zo4C/fR/Z11C+bAEFOy7bz7EXfMn8Akw=";

  excludedPackages = [ "dev" ];

  buildInputs = [
    libpg_query
    xxHash
  ];

  # Tests require a running docker daemon
  doCheck = false;

  meta = {
    description = "PostgreSQL zero-downtime migrations made easy";
    license = lib.licenses.asl20;
    mainProgram = "pgroll";
    homepage = "https://github.com/xataio/pgroll";
    maintainers = with lib.maintainers; [ ilyakooo0 ];
  };
}

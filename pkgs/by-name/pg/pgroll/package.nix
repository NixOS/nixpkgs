{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libpg_query,
  xxHash,
}:

buildGoModule rec {
  pname = "pgroll";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${version}";
    hash = "sha256-3ZA3qLAwwu0sT9R6R26GB/FF6vLxbofO5HUfPSBLcrg=";
  };

  proxyVendor = true;

  vendorHash = "sha256-tPGqa2Sa1N+WY5iprryil1Yzx0FbbgSp4CcNc9dNWhY=";

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

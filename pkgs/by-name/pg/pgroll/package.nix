{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libpg_query,
  xxHash,
}:
buildGoModule rec {
  pname = "pgroll";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${version}";
    hash = "sha256-iRa1dCUKmGUBpWjQXgKGrVu69WaTGQD8XhKmNxkF0JI=";
  };

  vendorHash = "sha256-XTypaCEB0+cfAmN4UyDRQgiF7spQhkiH2jCwjhd3I8Y=";

  excludedPackages = [
    "dev"
  ];

  buildInputs = [
    libpg_query
    xxHash
  ];

  # Tests require a running docker daemon
  doCheck = false;

  meta = {
    description = "PostgreSQL zero-downtime migrations made easy";
    license = lib.licenses.asl20;
    homepage = "https://github.com/xataio/pgroll";
    maintainers = with lib.maintainers; [ ilyakooo0 ];
  };
}

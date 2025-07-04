{
  buildGoModule,
  fetchFromGitHub,
  lib,
  libpg_query,
  xxHash,
}:

buildGoModule rec {
  pname = "pgroll";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    tag = "v${version}";
    hash = "sha256-8yrChHTNcj0Hphme5PuECkkxmppk16y8+NoC2yJ/B7Y=";
  };

  proxyVendor = true;

  vendorHash = "sha256-pK1cR62cGt1OE8Rz2qTb6ZBDCnuqes9HJGY7QOREv6E=";

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

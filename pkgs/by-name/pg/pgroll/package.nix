{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "pgroll";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    rev = "v${version}";
    hash = "sha256-XZrgJZR6CWdQWgGMXlEyZ5De6bu/u7+YvYvq6id9YzM=";
  };

  vendorHash = "sha256-+6HpxqQxGpIAyfn+38UeW2ksv5WyX67AT5e9JgQBI+k=";

  # Tests require a running docker daemon
  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL zero-downtime migrations made easy";
    license = licenses.asl20;
    homepage = "https://github.com/xataio/pgroll";
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}

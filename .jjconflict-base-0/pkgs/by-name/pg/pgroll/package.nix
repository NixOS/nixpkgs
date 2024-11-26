{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "pgroll";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    rev = "v${version}";
    hash = "sha256-7hIdm/qdcwlXC+vrEbjmBunORfEyItsr+Hia5u4ZBZk=";
  };

  vendorHash = "sha256-jP4tTV/4kgT86d46L47Jcr/7ZtP2rL8boZiwqLvYo40=";

  # Tests require a running docker daemon
  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL zero-downtime migrations made easy";
    license = licenses.asl20;
    homepage = "https://github.com/xataio/pgroll";
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}

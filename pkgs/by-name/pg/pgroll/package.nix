{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "pgroll";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    rev = "v${version}";
    hash = "sha256-VYGwIJsPVilFxvglj+E7H9NpqUV1CV/ggBP3gFleWIA=";
  };

  vendorHash = "sha256-Fz+o1jSoMfqKYo1I7VUFqbhBEgcoQEx7aYsmzCLsbnI=";

  # Tests require a running docker daemon
  doCheck = false;

  meta = with lib; {
    description = "PostgreSQL zero-downtime migrations made easy";
    license = licenses.asl20;
    homepage = "https://github.com/xataio/pgroll";
    maintainers = with maintainers; [ ilyakooo0 ];
  };
}

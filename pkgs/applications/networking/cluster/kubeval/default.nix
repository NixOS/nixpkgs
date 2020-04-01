{ stdenv, lib, fetchFromGitHub, buildGoModule, makeWrapper }:

buildGoModule rec {
  pname = "kubeval";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = "${version}";
    sha256 = "0kpwk7bv36m3i8vavm1pqc8l611c6l9qbagcc64v6r85qig4w5xv";
  };

  modSha256 = "0y9x44y3bchi8xg0a6jmp2rmi8dybkl6qlywb6nj1viab1s8dd4y";

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = https://github.com/instrumenta/kubeval;
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    platforms = platforms.all;
  };
}

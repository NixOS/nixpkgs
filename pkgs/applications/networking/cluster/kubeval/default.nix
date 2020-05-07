{ stdenv, lib, fetchFromGitHub, buildGoModule, makeWrapper }:

buildGoModule rec {
  pname = "kubeval";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "instrumenta";
    repo = "kubeval";
    rev = "${version}";
    sha256 = "05li0qv4q7fy2lr50r6c1r8dhx00jb1g01qmgc72a9zqp378yiq0";
  };

  modSha256 = "0y9x44y3bchi8xg0a6jmp2rmi8dybkl6qlywb6nj1viab1s8dd4y";

  meta = with lib; {
    description = "Validate your Kubernetes configuration files";
    homepage = "https://github.com/instrumenta/kubeval";
    license = licenses.asl20;
    maintainers = with maintainers; [ johanot nicknovitski ];
    platforms = platforms.all;
  };
}

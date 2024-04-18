{ lib
, buildGoModule
, fetchFromGitHub
, libxcrypt
, nixosTests
}:

buildGoModule rec {
  pname = "ssh3";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "francoismichel";
    repo = "ssh3";
    rev = "v${version}";
    hash = "sha256-ZtQAJwGvNlJWUoDa6bS3AEdM3zbNMPQGdaIhR+yIonw=";
  };

  buildInputs = [
    libxcrypt
  ];

  vendorHash = "sha256-VUNvb7m1nnH+mXUsnIKyPKJEVSMXBAaS4ihi5DZeFiI=";

  ldflags = [ "-s" "-w" ];

  passthru.tests = {
    inherit (nixosTests) ssh3;
  };

  meta = with lib; {
    description = "Revisit of the SSH protocol using QUIC + TLS 1.3 and HTTP authorization";
    homepage = "https://github.com/francoismichel/ssh3";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "ssh3";
  };
}

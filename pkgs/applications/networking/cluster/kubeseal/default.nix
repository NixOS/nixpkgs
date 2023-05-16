{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubeseal";
<<<<<<< HEAD
  version = "0.23.1";
=======
  version = "0.20.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-FhkeovWuDQZ7KwyIk6YY/iWfRQxTUT0fcAJcCiTZ9Cg=";
  };

  vendorHash = "sha256-mtWh5nJrdy7PIk4+S+66Xgqpllg6lAyc73lW/bjV5AE=";
=======
    sha256 = "sha256-G7v5hRSUtO7AwotQ/2eftfs31+IbyzGHydT/IR1bhOY=";
  };

  vendorHash = "sha256-fndK1PO4CfTGQV1f9PJ+ju5VUW/RIE5i8IBARJn0g6g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/kubeseal" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  meta = with lib; {
    description = "A Kubernetes controller and tool for one-way encrypted Secrets";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
<<<<<<< HEAD
    changelog = "https://github.com/bitnami-labs/sealed-secrets/blob/v${version}/RELEASE-NOTES.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}

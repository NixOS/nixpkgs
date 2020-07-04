{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "kompose";
  version = "1.21.0";

  goPackagePath = "github.com/kubernetes/kompose";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "kubernetes";
    repo = "kompose";
    sha256 = "15a1alf6ywwfc4z5kdcnv64fp3cfy3qrcw62ny6xyn1kh1w24vkh";
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    for shell in bash zsh; do
      $out/bin/kompose completion $shell > kompose.$shell
      installShellCompletion kompose.$shell
    done
  '';

  meta = with lib; {
    description = "A tool to help users who are familiar with docker-compose move to Kubernetes";
    homepage = "https://kompose.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ thpham vdemeester ];
    platforms = platforms.unix;
  };
}

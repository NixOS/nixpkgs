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
    $bin/bin/kompose completion bash > kompose.bash
    $bin/bin/kompose completion zsh > kompose.zsh
    installShellCompletion kompose.{bash,zsh}
  '';

  meta = with lib; {
    description = "A tool to help users who are familiar with docker-compose move to Kubernetes";
    homepage = "https://kompose.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ thpham vdemeester ];
    platforms = platforms.unix;
  };
}

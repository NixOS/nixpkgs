{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fluxcd";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    sha256 = "1y586704xckhyyqmmgq4g6csnf9iqi7xb2vqv5sqyz96ik3kg9vy";
  };

  vendorSha256 = "1kyj65fc2q1sc4aiy87i2wzf7kqybjf08mmmw0ajcxszcr0mcadb";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [ "cmd/flux" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/flux --version | grep ${version} > /dev/null
  '';

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/flux completion $shell > flux.$shell
      installShellCompletion flux.$shell
    done
  '';

  meta = with lib; {
    description = "Open and extensible continuous delivery solution for Kubernetes";
    longDescription = ''
      Flux is a tool for keeping Kubernetes clusters in sync
      with sources of configuration (like Git repositories), and automating
      updates to configuration when there is new code to deploy.
    '';
    homepage = "https://fluxcd.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jlesquembre ];
    platforms = platforms.unix;
  };
}

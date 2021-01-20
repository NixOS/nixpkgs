{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "fluxcd";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    sha256 = "sha256-A5sEv8d6T0tvhD5UzZ2h2cymtXSO2h68pnD8MGg+Dfo=";
  };

  vendorSha256 = "sha256-eh5oUOLgZLIODL58WI1trXerHDWrIiclkrv/w0lvzL4=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [ "cmd/flux" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

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

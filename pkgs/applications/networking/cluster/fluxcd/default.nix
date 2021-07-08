{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles }:

let
  version = "0.16.0";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    sha256 = "sha256-/uD0hxtTJSr+2tZcwzOIQcEbikHOshWukEBSaK3FiP4=";
    stripRoot = false;
  };
in

buildGoModule rec {
  inherit version;

  pname = "fluxcd";

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    sha256 = "sha256-r9Tg6aU8aIA87Mw+HFMdPe9uC+3bfGOnuAIrmB1nlRs=";
  };

  vendorSha256 = "sha256-zaOOwgljqhmIXZPZSMgMsVi02bBqQOag+6uVhxKsu9U=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/flux" ];

  buildFlagsArray = [ "-ldflags=-s -w -X main.VERSION=${version}" ];

  postUnpack = ''
    cp -r ${manifests} source/cmd/flux/manifests
  '';

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

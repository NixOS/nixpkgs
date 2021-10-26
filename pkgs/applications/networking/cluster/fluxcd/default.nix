{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles }:

let
  version = "0.19.1";
  sha256 = "184f5q3aa4p6gjdmr8x6a97rzaj64ws8bf3q8sz4xjyznznwcpp0";
  manifestsSha256 = "1xxf572yvjmik7dvijz810lxzfj7irddznl4icidn7hrljzjrv95";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    sha256 = manifestsSha256;
    stripRoot = false;
  };
in

buildGoModule rec {
  pname = "fluxcd";
  inherit version;

  src = fetchFromGitHub {
    owner = "fluxcd";
    repo = "flux2";
    rev = "v${version}";
    inherit sha256;
  };

  vendorSha256 = "sha256-1ZIeS42LoreZKkzDNZxmF17HeDWWVo49CaZDrIR2U9g=";

  postUnpack = ''
    cp -r ${manifests} source/cmd/flux/manifests
  '';

  patches = [
    ./patches/disable-tests-ssh_key.patch
  ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  subPackages = [ "cmd/flux" ];

  # Required to workaround test error:
  #   panic: mkdir /homeless-shelter: permission denied
  HOME="$TMPDIR";

  nativeBuildInputs = [ installShellFiles ];

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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Open and extensible continuous delivery solution for Kubernetes";
    longDescription = ''
      Flux is a tool for keeping Kubernetes clusters in sync
      with sources of configuration (like Git repositories), and automating
      updates to configuration when there is new code to deploy.
    '';
    homepage = "https://fluxcd.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ jlesquembre superherointj ];
  };
}

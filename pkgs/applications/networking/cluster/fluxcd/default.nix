{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles }:

let
  version = "0.18.3";
  sha256 = "0nvvjc0ml1irn7vxyq4m43qimp128cx8hczk21y5m39i2rg4yzx4";
  manifestsSha256 = "1qgw9ij0b85vvdx03wmbbwanhq1hf69wphy58lsqwf33rdq0bb1m";

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

  vendorSha256 = "0vgi5cnvmc98xa2ibpgvvqlc90hf3gj3v17yqncid596ig3dnqsc";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/flux" ];

  ldflags = [ "-s" "-w" "-X main.VERSION=${version}" ];

  postUnpack = ''
    cp -r ${manifests} source/cmd/flux/manifests
  '';

  # Required to workaround test error:
  #   panic: mkdir /homeless-shelter: permission denied
  HOME="$TMPDIR";

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

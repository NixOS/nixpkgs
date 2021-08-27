{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles }:

let
  version = "0.17.0";

  manifests = fetchzip {
    url = "https://github.com/fluxcd/flux2/releases/download/v${version}/manifests.tar.gz";
    sha256 = "15ffb8damn935sfnqpshiyaazpldjcq411xrcfngpp7ncl9vbgwm";
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
    sha256 = "1pw558d64c6ynqnnadhg8vbi4ql6f5y81l9hpxi0ki5myj2kx6an";
  };

  vendorSha256 = "sha256-FUASe7EQ8YVv3R6fPPLtsvMibe00Ox596GoTyKt0S+E=";

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

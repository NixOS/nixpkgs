{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles }:

let
  version = "0.17.2";
  sha256 = "0kcdx4ldnshk4pqq37a7p08xr5cpsjrbrifk9fc3jbiw39m09mhf";
  manifestsSha256 = "1v6md4xh4sq1vmb5a8qvb66l101fq75lmv2s4j2z3walssb5mmgj";

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

  vendorSha256 = "sha256-glifJ0V3RwS7E6EWZsCa88m0MK883RhPSXCsAmMggVs=";

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

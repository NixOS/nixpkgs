{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:
let
  generic = { version, sha256, rev ? version, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "version" "sha256" "rev" ]; in
    buildGoModule
      {
        pname = "kops";
        inherit version;

        src = fetchFromGitHub {
          rev = rev;
          owner = "kubernetes";
          repo = "kops";
          inherit sha256;
        };

        vendorSha256 = null;

        nativeBuildInputs = [ installShellFiles ];

        subPackages = [ "cmd/kops" ];

        ldflags = [
          "-s"
          "-w"
          "-X k8s.io/kops.Version=${version}"
          "-X k8s.io/kops.GitVersion=${version}"
        ];

        doCheck = false;

        postInstall = ''
          installShellCompletion --cmd kops \
            --bash <($GOPATH/bin/kops completion bash) \
            --fish <($GOPATH/bin/kops completion fish) \
            --zsh <($GOPATH/bin/kops completion zsh)
        '';

        meta = with lib; {
          description = "Easiest way to get a production Kubernetes up and running";
          homepage = "https://github.com/kubernetes/kops";
          changelog = "https://github.com/kubernetes/kops/tree/master/docs/releases";
          license = licenses.asl20;
          maintainers = with maintainers; [ offline zimbatm diegolelis yurrriq ];
          platforms = platforms.unix;
        };
      } // attrs';
in
rec {
  mkKops = generic;

  kops_1_22 = mkKops rec {
    version = "1.22.4";
    sha256 = "sha256-osU7yI77ZALGrAGuP8qAgv+ogDRn+BSVmcjPbi/WEKE=";
    rev = "v${version}";
  };

  kops_1_23 = mkKops rec {
    version = "1.23.2";
    sha256 = "sha256-9GANjGRS9QaJw+CEeMv/f+rEu37QV2YxMvSRSH6+3PM=";
    rev = "v${version}";
  };

  kops_1_24 = mkKops rec {
    version = "1.24.1";
    sha256 = "sha256-rePNCk76/j6ssvi+gSvxn4GqoW/QovTFCJ0rj2Dd+0A=";
    rev = "v${version}";
  };

}

{ lib, buildGoPackage, fetchFromGitHub, go-bindata, installShellFiles }:
let
  goPackagePath = "k8s.io/kops";

  generic = { version, sha256, rev ? version, ... }@attrs:
    let attrs' = builtins.removeAttrs attrs [ "version" "sha256" "rev" ]; in
    buildGoPackage
      {
        pname = "kops";
        inherit version;

        inherit goPackagePath;

        src = fetchFromGitHub {
          rev = rev;
          owner = "kubernetes";
          repo = "kops";
          inherit sha256;
        };

        nativeBuildInputs = [ go-bindata installShellFiles ];
        subPackages = [ "cmd/kops" ];

        ldflags = [
          "-X k8s.io/kops.Version=${version}"
          "-X k8s.io/kops.GitVersion=${version}"
        ];

        preBuild = ''
          (cd go/src/k8s.io/kops
           go-bindata -o upup/models/bindata.go -pkg models -prefix upup/models/ upup/models/...)
        '';

        postInstall = ''
          for shell in bash zsh; do
            $out/bin/kops completion $shell > kops.$shell
            installShellCompletion kops.$shell
          done
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

  kops_1_21 = mkKops rec {
    version = "1.21.4";
    sha256 = "sha256-f2xOVa3N/GH5IoI6H/QwDdKTeQoF/kEHX6lNytCZ9cs=";
    rev = "v${version}";
  };

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
}

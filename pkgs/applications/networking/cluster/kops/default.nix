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

        vendorHash = null;

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
        };
      } // attrs';
in
rec {
  mkKops = generic;

  kops_1_26 = mkKops rec {
    version = "1.26.6";
    sha256 = "sha256-qaehvPgB3phZl/K577hig4G4RxAUi6Im94vXP5ctnWM=";
    rev = "v${version}";
  };

  kops_1_27 = mkKops rec {
    version = "1.27.1";
    sha256 = "sha256-WV+0380yj8GHckY4PDM3WspbZ/YuYZOAQEMd2ygEOjo=";
    rev = "v${version}";
  };

  kops_1_28 = mkKops rec {
    version = "1.28.0";
    sha256 = "sha256-a/3amvgGG7Gro6K7uIi20jwCo+JAlSuPB3/EUf75hxc=";
    rev = "v${version}";
  };
}

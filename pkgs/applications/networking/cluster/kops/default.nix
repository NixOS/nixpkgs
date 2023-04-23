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

  kops_1_24 = mkKops rec {
    version = "1.24.5";
    sha256 = "sha256-U5OSiU0t2gyvyNd07y68Fb+HaXp5wQN4t0CBPOOMd/M=";
    rev = "v${version}";
  };

  kops_1_25 = mkKops rec {
    version = "1.25.4";
    sha256 = "sha256-Q40d62D+H7CpLmrjweCy75U3LgnHEV2pFZs2Ze+koqo=";
    rev = "v${version}";
  };

  kops_1_26 = mkKops rec {
    version = "1.26.2";
    sha256 = "sha256-PY/dcKyciPg3OyUPeBwYed6ADprpI2/+8d8SuGTXWqc=";
    rev = "v${version}";
  };
}

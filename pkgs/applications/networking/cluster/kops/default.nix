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

  kops_1_23 = mkKops rec {
    version = "1.23.4";
    sha256 = "sha256-hUj/kUyaqo8q3SJTkd5+9Ld8kfE8wCYNJ2qIATjXqhU=";
    rev = "v${version}";
  };

  kops_1_24 = mkKops rec {
    version = "1.24.3";
    sha256 = "sha256-o84060P2aHTIm61lSkz2/GqzYd2NYk1zKgGdNaHlWfA=";
    rev = "v${version}";
  };

  kops_1_25 = mkKops rec {
    version = "1.25.2";
    sha256 = "sha256-JJGb12uuOvZQ+bA82nrs9vKRT2hEvnPrOH8XNHfYVD8=";
    rev = "v${version}";
  };
}

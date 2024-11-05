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
          mainProgram = "kops";
          homepage = "https://github.com/kubernetes/kops";
          changelog = "https://github.com/kubernetes/kops/tree/master/docs/releases";
          license = licenses.asl20;
          maintainers = with maintainers; [ offline zimbatm diegolelis yurrriq ];
        };
      } // attrs';
in
rec {
  mkKops = generic;

  kops_1_27 = mkKops rec {
    version = "1.27.1";
    sha256 = "sha256-WV+0380yj8GHckY4PDM3WspbZ/YuYZOAQEMd2ygEOjo=";
    rev = "v${version}";
  };

  kops_1_28 = mkKops rec {
    version = "1.28.7";
    sha256 = "sha256-rTf7+w/o8MGSBKV9wCzZOEI0v31exZhOJpRABeF/KyI=";
    rev = "v${version}";
  };

  kops_1_29 = mkKops rec {
    version = "1.29.2";
    sha256 = "sha256-SRj0x9N+yfTG/UL/hu1ds46Zt6d5SUYU0PA9lPHO6jQ=";
    rev = "v${version}";
  };

  kops_1_30 = mkKops rec {
    version = "1.30.1";
    sha256 = "sha256-aj2OnjkXlBEH830RoJiAlhiFfS1zjVoX38PrsgAaB7A=";
    rev = "v${version}";
  };
}

{ stdenv, lib, buildGoPackage, fetchFromGitHub, go-bindata }:

let
  goPackagePath = "k8s.io/kops";

  generic = { version, sha256, ...}@attrs:
    let attrs' = builtins.removeAttrs attrs ["version" "sha256"] ; in
      buildGoPackage {
        name = "kops-${version}";

        inherit goPackagePath;

        src = fetchFromGitHub {
          rev = version;
          owner = "kubernetes";
          repo = "kops";
          inherit sha256;
        };

        buildInputs = [go-bindata];
        subPackages = ["cmd/kops"];

        buildFlagsArray = ''
          -ldflags=
              -X k8s.io/kops.Version=${version}
              -X k8s.io/kops.GitVersion=${version}
        '';

        preBuild = ''
          (cd go/src/k8s.io/kops
           go-bindata -o upup/models/bindata.go -pkg models -prefix upup/models/ upup/models/...)
        '';

        postInstall = ''
          mkdir -p $bin/share/bash-completion/completions
          mkdir -p $bin/share/zsh/site-functions
          $bin/bin/kops completion bash > $bin/share/bash-completion/completions/kops
          $bin/bin/kops completion zsh > $bin/share/zsh/site-functions/_kops
        '';

        meta = with stdenv.lib; {
          description = "Easiest way to get a production Kubernetes up and running";
          homepage = https://github.com/kubernetes/kops;
          license = licenses.asl20;
          maintainers = with maintainers; [offline zimbatm];
          platforms = platforms.unix;
        };
      } // attrs';
in rec {

  mkKops = generic;

  kops_1_12 = mkKops {
    version = "1.12.2";
    sha256 = "0937crwifnld7r5pf5gvab9ibmf8k44dafr9y3hld2p01ijrari1";
  };
}

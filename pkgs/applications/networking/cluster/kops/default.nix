{ stdenv, lib, buildGoPackage, fetchFromGitHub, go-bindata }:

let
  goPackagePath = "k8s.io/kops";

  generic = { version, sha256, ...}@attrs:
    let attrs' = builtins.removeAttrs attrs ["version" "sha256"] ; in
      buildGoPackage {
        pname = "kops";
        inherit version;

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
          maintainers = with maintainers; [offline zimbatm kampka];
          platforms = platforms.unix;
        };
      } // attrs';
in rec {

  mkKops = generic;

  kops_1_12 = mkKops {
    version = "1.12.3";
    sha256 = "0rpbaz54l5v1z7ab5kpxcb4jyakkl5ysgz1sxajqmw2d6dvf7xly";
  };

  kops_1_13 = mkKops {
    version = "1.13.2";
    sha256 = "0lkkg34vn020r62ga8vg5d3a8jwvq00xlv3p1s01nkz33f6salng";
  };
  
  kops_1_14 = mkKops {
    version = "1.14.1";
    sha256 = "0ikd8qwrjh8s1sc95g18sm0q6p33swz2m1rjd8zw34mb2w9jv76n";
  };

  kops_1_15 = mkKops {
    version = "1.15.2";
    sha256 = "1sjfd7pfi81ccq1dkgkh9xx6y94bqzlp727pvyf7l01x3d14z2b3";
  };
}

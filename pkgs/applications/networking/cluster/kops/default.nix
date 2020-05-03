{ stdenv, lib, buildGoPackage, fetchFromGitHub, go-bindata, installShellFiles }:

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

        nativeBuildInputs = [ go-bindata installShellFiles ];
        subPackages = [ "cmd/kops" ];

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
          for shell in bash zsh; do
            $bin/bin/kops completion $shell > kops.$shell
            installShellCompletion kops.$shell
          done
        '';

        meta = with stdenv.lib; {
          description = "Easiest way to get a production Kubernetes up and running";
          homepage = "https://github.com/kubernetes/kops";
          license = licenses.asl20;
          maintainers = with maintainers; [ offline zimbatm kampka ];
          platforms = platforms.unix;
        };
      } // attrs';
in rec {

  mkKops = generic;

  kops_1_15 = mkKops {
    version = "1.15.2";
    sha256 = "1sjfd7pfi81ccq1dkgkh9xx6y94bqzlp727pvyf7l01x3d14z2b3";
  };

  kops_1_16 = mkKops {
    version = "1.16.1";
    sha256 = "04ji1703z6b3rd4wmccah68api0jj2bndzkgdzqi855gccqbmi5g";
  };
}

{ stdenv, lib, buildGoPackage, fetchFromGitHub, go-bindata, installShellFiles }:
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
            $out/bin/kops completion $shell > kops.$shell
            installShellCompletion kops.$shell
          done
        '';

        meta = with stdenv.lib; {
          description = "Easiest way to get a production Kubernetes up and running";
          homepage = "https://github.com/kubernetes/kops";
          changelog = "https://github.com/kubernetes/kops/tree/master/docs/releases";
          license = licenses.asl20;
          maintainers = with maintainers; [ offline zimbatm kampka ];
          platforms = platforms.unix;
        };
      } // attrs';
in
rec {

  mkKops = generic;

  kops_1_16 = mkKops {
    version = "1.16.4";
    sha256 = "0qi80hzd5wc8vn3y0wsckd7pq09xcshpzvcr7rl5zd4akxb0wl3f";
  };

  kops_1_17 = mkKops {
    version = "1.17.2";
    sha256 = "0fmrzjz163hda6sl1jkl7cmg8fw6mmqb9953048jnhmd3w428xlz";
  };

  kops_1_18 = mkKops rec {
    version = "1.18.2";
    sha256 = "17na83j6sfhk69w9ssvicc0xd1904z952ad3zzbpha50lcy6nlhp";
    rev = "v${version}";
  };
}
